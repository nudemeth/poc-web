package nudemeth.poc.ordering.api.controller

import akka.actor.{ ActorRef, ActorSystem }
import akka.event.Logging
import akka.http.scaladsl.model.StatusCodes
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.server.directives.MethodDirectives.{ get, post }
import akka.http.scaladsl.server.directives.RouteDirectives.complete
import akka.http.scaladsl.server.Route
import akka.http.scaladsl.server.directives.Credentials
import akka.pattern.ask
import akka.util.Timeout
import nudemeth.poc.ordering.api.application.query.viewmodel.{ Order, OrderSummary }
import nudemeth.poc.ordering.api.controller.OrderingRegistryActor._
import nudemeth.poc.ordering.api.infrastructure.service.IdentityService.{ ExtractUserIdentity, UserIdentity }

import scala.concurrent.Future
import scala.concurrent.duration._

trait OrderingRoutes extends JsonSupport {
  // we leave these abstract, since they will be provided by the App
  implicit def system: ActorSystem
  lazy val log = Logging(system, classOf[OrderingRoutes])
  // other dependencies that APIRoutes use
  def orderingRegistryActor: ActorRef
  def identityRegistryActor: ActorRef
  // Required by the `ask` (?) method below
  implicit lazy val timeout: Timeout = Timeout(5.seconds) // usually we'd obtain the timeout from the system's configuration

  lazy val orderingRoutes: Route =
    pathPrefix("api" / "v1" / "orders") {
      concat(
        getOrdersRoute,
        postOrderRoute,
        getOrderRoute,
        deleteOrderRoute)
    }

  def tokenAuthenticator(credentials: Credentials): Future[Option[UserIdentity]] = {
    credentials match {
      case Credentials.Provided(token) => (identityRegistryActor ? ExtractUserIdentity(token)).mapTo[Option[UserIdentity]]
      case _ => Future.successful(None)
    }
  }

  val getOrdersRoute: Route = get {
    pathEndOrSingleSlash {
      authenticateOAuth2Async(realm = "api", tokenAuthenticator) { identity =>
        val orders: Future[Vector[OrderSummary]] = (orderingRegistryActor ? GetOrders(identity)).mapTo[Vector[OrderSummary]]
        complete(orders)
      }
    }
  }

  val postOrderRoute: Route = post {
    pathEndOrSingleSlash {
      entity(as[Order]) { order =>
        val orderCreated: Future[ActionPerformed] =
          (orderingRegistryActor ? CreateOrder(order)).mapTo[ActionPerformed]
        onSuccess(orderCreated) { performed =>
          log.info("Created order [{}]: {}", order.orderNumber.toString, performed.description)
          complete((StatusCodes.Created, performed))
        }
      }
    }
  }
  val getOrderRoute: Route = get {
    path(JavaUUID) { id =>
      val maybeOrder: Future[Option[Order]] = (orderingRegistryActor ? GetOrder(id)).mapTo[Option[Order]]
      rejectEmptyResponse {
        complete(maybeOrder)
      }
    }
  }
  val deleteOrderRoute: Route = delete {
    path(JavaUUID) { id =>
      val userDeleted: Future[ActionPerformed] =
        (orderingRegistryActor ? DeleteOrder(id)).mapTo[ActionPerformed]
      onSuccess(userDeleted) { performed =>
        log.info("Deleted order [{}]: {}", id.toString, performed.description)
        complete((StatusCodes.OK, performed))
      }
    }
  }
}
