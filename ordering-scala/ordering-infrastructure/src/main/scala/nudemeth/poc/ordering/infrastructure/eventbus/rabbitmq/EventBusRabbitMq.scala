package nudemeth.poc.ordering.infrastructure.eventbus.rabbitmq

import java.nio.charset.StandardCharsets

import com.newmotion.akka.rabbitmq.{ BasicProperties, Channel, ChannelActor, Connection, CreateChannel }
import com.rabbitmq.client.AMQP.BasicProperties
import nudemeth.poc.ordering.infrastructure.eventbus._
import spray.json._
import scala.reflect.runtime.universe._

case class EventBusRabbitMq(connection: Connection, eventJsonConverter: IntegrationEventJsonConverterOperations, subsManager: EventBusSubscriptionsManager, queueName: String) extends EventBusOperations {

  implicit object IntegrationEventFormat extends RootJsonFormat[IntegrationEvent] {
    def write(event: IntegrationEvent): JsValue = eventJsonConverter.writeJson(event)
    def read(value: JsValue): IntegrationEvent = eventJsonConverter.readJson(value)
  }

  private val BROKER_NAME = "eshop_event_bus"

  private def publish(channel: Channel, eventName: String, body: Array[Byte]): Unit = {
    val props = new BasicProperties().builder().deliveryMode(2).build()
    channel.exchangeDeclare(BROKER_NAME, "direct")
    channel.basicPublish(BROKER_NAME, eventName, true, props, body)
  }

  override def publish(event: IntegrationEvent): Unit = {
    val channel = connection.createChannel()
    val body = event.toJson.compactPrint.getBytes(StandardCharsets.UTF_8)
    publish(channel, event.getClass.getName, body)
  }

  override def subscribe[T <: IntegrationEvent, TH <: IntegrationEventHandlerOperations[T]]()(implicit eventTag: TypeTag[T], handlerTag: TypeTag[TH]): Unit = {
    val eventName = subsManager.getEventKey[T]()
    doInternalSubscription(eventName)
    subsManager.addSubscription[T, TH]()
  }

  override def unsubscribe[T <: IntegrationEvent, TH <: IntegrationEventHandlerOperations[T]]()(implicit eventTag: TypeTag[T], handlerTag: TypeTag[TH]): Unit = {
    subsManager.removeSubscription[T, TH]()
  }

  private def doInternalSubscription(eventName: String): Unit = {
    val containsKey = subsManager.hasSubscriptionsForEvent(eventName)
    if (!containsKey) {
      val channel = connection.createChannel()
      channel.queueBind(queueName, BROKER_NAME, eventName)
    }
  }

}
