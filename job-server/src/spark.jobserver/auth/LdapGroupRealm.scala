package spark.jobserver.auth

import org.apache.shiro.realm.ldap.JndiLdapRealm
import org.apache.shiro.realm.ldap.LdapContextFactory
import org.apache.shiro.realm.ldap.JndiLdapContextFactory
import org.apache.shiro.realm.ldap.LdapUtils
import org.apache.shiro.subject.PrincipalCollection
import org.apache.shiro.authz._
import javax.naming.ldap.LdapContext
import javax.naming.directory._
import org.slf4j.LoggerFactory

/**
 * LDAP realm implementation that retrieves group information from LDAP and matches
 * the 'member' attribute values of each group against the given user.
 *
 * @note not all LDAP installations use the member property.... we might have to add
 *   memberOf matches as well and others
 *
 * @author KNIME (basics in Java stem from different sources by various authors from stackoverflow and such)
 */
class LdapGroupRealm extends JndiLdapRealm {
  import collection.JavaConverters._

  private val logger = LoggerFactory.getLogger(getClass)

  private val searchCtls: SearchControls = {
    val c = new SearchControls();
    c.setSearchScope(SearchControls.SUBTREE_SCOPE);
    c
  }

  lazy val searchBase: String = getContextFactory() match {
    case jni: JndiLdapContextFactory =>
      getEnvironmentParam(jni, "ldap.searchBase")
    case _ =>
      throw new RuntimeException("Configuration error: " +
        "LdapGroupRealm requires setting of the parameter 'searchBase'")
  }

  lazy val allowedGroups: Option[Array[String]] = getContextFactory() match {
    case jni: JndiLdapContextFactory =>
      val groups = getEnvironmentParam(jni, "ldap.allowedGroups").
        split("\"").filter(group => group.replaceAll("[, ]", "").length() > 0)
      if (groups.isEmpty) {
        None
      } else {
        Some(groups)
      }
    case _ =>
      None
  }

  private def getEnvironmentParam(jni: JndiLdapContextFactory, param: String): String = {
    val value = jni.getEnvironment().get(param)
    value match {
      case null =>
        //tell user what is missing instead of just throwing a NPE
        throw new RuntimeException("Configuration error: " +
          "LdapGroupRealm requires setting of the parameter '" + param + "'")
      case v =>
        v.toString
    }
  }

  override def queryForAuthorizationInfo(principals: PrincipalCollection,
                                         ldapContextFactory: LdapContextFactory): AuthorizationInfo = {

    val username = getAvailablePrincipal(principals).toString
    val ldapContext = ldapContextFactory.getSystemLdapContext()
    try {
      queryForAuthorizationInfo(ldapContext, username)
    } finally {
      LdapUtils.closeContext(ldapContext);
    }
  }

  def queryForAuthorizationInfo(ldapContext: LdapContext, username: String): AuthorizationInfo = {
    val roleNames = getRoleNamesForUser(ldapContext, username)
    if (isInAllowedGroupOrNoCheckOnGroups(roleNames)) {
      new SimpleAuthorizationInfo(roleNames.asJava)
    } else {
      throw new AuthorizationException(LdapGroupRealm.ERROR_MSG_NO_VALID_GROUP)
    }
  }

  //TODO - can (should?) this information be cached?
  def retrieveGroups(ldapContext: LdapContext): Map[String, Set[String]] = {
    logger.trace("Retrieving group memberships.")

    val groupSearchAtts: Array[Object] = Array()

    val groupAnswer = ldapContext.search(searchBase, LdapGroupRealm.groupMemberFilter,
      groupSearchAtts, searchCtls).asScala

    groupAnswer.map { sr2 =>
      logger.debug("Checking members of group [%s]", sr2.getName())
      sr2.getName() -> getMembers(sr2)
    }.toMap
  }

  private def getMembers(sr: SearchResult): Set[String] = {
    val attrs: Attributes = sr.getAttributes()

    if (attrs != null) {
      LdapUtils.getAllAttributeValues(attrs.get("member")).asScala.toSet
    } else {
      Set()
    }
  }

  def getRoleNamesForUser(ldapContext: LdapContext, username: String): Set[String] = {
    val searchAtts: Array[Object] = Array(username)

    val answer: Iterator[SearchResult] = ldapContext.search(searchBase, LdapGroupRealm.personSearchFilter,
      searchAtts, searchCtls).asScala

    val members = retrieveGroups(ldapContext)

    answer.map { userSearchResult =>
      val fullGroupMemberName = "%s,%s" format (userSearchResult.getName(), searchBase)
      members.filter(entry => {
        entry._2.contains(fullGroupMemberName)
      }).map(e => e._1)
    }.flatten.toSet
  }

  def isInAllowedGroupOrNoCheckOnGroups(roles: Set[String]): Boolean = {
    allowedGroups match {
      case Some(groups) =>
        roles.exists(r => groups.contains(r))
      case None =>
        true
    }
  }
}

object LdapGroupRealm {
  val groupMemberFilter = "(member=*)"
  val personSearchFilter = "(&(objectClass=person)(CN={0}))"
  val ERROR_MSG_NO_VALID_GROUP = "no valid group found"
}
