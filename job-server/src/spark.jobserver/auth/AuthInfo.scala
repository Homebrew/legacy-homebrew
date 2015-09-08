package spark.jobserver.auth

/**
 * based on example provided by Mario Camou
 * at
 * http://www.tecnoguru.com/blog/2014/07/07/implementing-http-basic-authentication-with-spray/
 */
class AuthInfo(val user: User) {
  def hasPermission(permission: String): Boolean = {
    //no further checks, all authenticated users can perform all
    // all operations
    true
    // someone could add code here to check whether user has the given permission
  }

  override def equals(other: Any): Boolean =
    other match {
      case that: AuthInfo =>
        (that canEqual this) &&
          user == that.user
      case _ => false
    }

  def canEqual(other: Any): Boolean =
    other.isInstanceOf[AuthInfo]

  override def hashCode: Int = user.hashCode

}
