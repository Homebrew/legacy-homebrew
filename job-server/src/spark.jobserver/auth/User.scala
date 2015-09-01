package spark.jobserver.auth

/**
 * minimal user info, for more advanced permission checking, it might be necessary
 * to add more properties such as group memberships
 */
case class User(login: String)
