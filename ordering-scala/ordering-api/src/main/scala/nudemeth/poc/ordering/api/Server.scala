package nudemeth.poc.ordering.api

//#quick-start-server
import scala.concurrent.{ Await, ExecutionContext, Future }
import scala.concurrent.duration.Duration
import scala.util.{ Failure, Success }
import akka.actor.{ ActorRef, ActorSystem }
import akka.http.scaladsl.Http
import akka.http.scaladsl.server.Route
import akka.stream.ActorMaterializer
import nudemeth.poc.ordering.api.application.query.{ OrderQuery, OrderQueryable }
import nudemeth.poc.ordering.api.controller.{ OrderingRegistryActor, OrderingRoutes }

//#main-class
object Server extends App with OrderingRoutes {

  // set up ActorSystem and other dependencies here
  //#main-class
  //#server-bootstrapping
  implicit val system: ActorSystem = ActorSystem("ordering-system")
  implicit val materializer: ActorMaterializer = ActorMaterializer()
  implicit val executionContext: ExecutionContext = system.dispatcher
  //#server-bootstrapping

  val orderingRepo: OrderQueryable = new OrderQuery()
  val orderingRegistryActor: ActorRef = system.actorOf(OrderingRegistryActor.props(orderingRepo), "ordering-actor")

  //#main-class
  // from the OrderingRoutes trait
  lazy val routes: Route = orderingRoutes
  //#main-class

  //#http-server
  val serverBinding: Future[Http.ServerBinding] = Http().bindAndHandle(routes, "localhost", 8080)

  serverBinding.onComplete {
    case Success(bound) =>
      println(s"Server online at http://${bound.localAddress.getHostString}:${bound.localAddress.getPort}/")
    case Failure(e) =>
      Console.err.println(s"Server could not start!")
      e.printStackTrace()
      system.terminate()
  }

  Await.result(system.whenTerminated, Duration.Inf)
  //#http-server
  //#main-class
}
//#main-class
//#quick-start-server