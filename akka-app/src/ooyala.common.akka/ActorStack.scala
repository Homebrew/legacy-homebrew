package ooyala.common.akka

import akka.actor.Actor

/**
 * A base trait for enabling stackable traits that enhance Actors.
 * Examples of stackable traits are included, and add logging, metrics, etc.
 *
 * == Actor classes ==
 * Actor classes that mix in this trait should define a wrappedReceive partial function
 * instead of the standard receive.
 *
 * Messages not handled by wrappedReceive will go, as usual, to unhandled().
 *
 * == Stacking traits ==
 * {{{
 * trait MyActorTrait extends ActorStack {
 *   override def receive: Receive = {
 *     case x =>
 *       println("Before calling wrappedReceive... do something")
 *       super.receive(x)
 *       println("After calling wrappedReceive... do something else")
 *   }
 * }
 * }}}
 */
trait ActorStack extends Actor {
  /** Actor classes should implement this partialFunction for standard actor message handling */
  def wrappedReceive: Receive

  /** Stackable traits should override and call super.receive(x) for stacking functionality */
  def receive: Receive = {
    case x => if (wrappedReceive.isDefinedAt(x)) wrappedReceive(x) else unhandled(x)
  }
}
