package spark.jobserver.auth

import org.scalatest.{ FunSpecLike, FunSpec, BeforeAndAfter, BeforeAndAfterAll, Matchers }
import org.apache.shiro.config.IniSecurityManagerFactory
import org.apache.shiro.mgt.DefaultSecurityManager
import org.apache.shiro.mgt.SecurityManager
import org.apache.shiro.realm.Realm
import org.apache.shiro.authz._
import org.apache.shiro.SecurityUtils
import org.apache.shiro.config.Ini
import javax.naming.ldap.InitialLdapContext
import javax.naming.ldap.LdapContext
import javax.naming._
import javax.naming.directory._

class LdapGroupRealmSpec extends FunSpecLike with Matchers {
  import collection.JavaConverters._

  private val IniConfig = """
# use this for basic ldap authorization, without group checking
# activeDirectoryRealm = org.apache.shiro.realm.ldap.JndiLdapRealm
# use this for checking group membership of users based on the 'member' attribute of the groups:
activeDirectoryRealm = spark.jobserver.auth.LdapGroupRealm
# search base for ldap groups:
activeDirectoryRealm.contextFactory.environment[ldap.searchBase] = dc=xxx,dc=org
activeDirectoryRealm.contextFactory.environment[ldap.allowedGroups] = "cn=group1,ou=groups", "", "cn=group2,ou=groups",,,,,
activeDirectoryRealm.contextFactory.environment[java.naming.security.credentials] = password
activeDirectoryRealm.contextFactory.url = ldap://xxx.yyy..org:389
activeDirectoryRealm.userDnTemplate = cn={0},ou=people,dc=xxx,dc=org

cacheManager = org.apache.shiro.cache.MemoryConstrainedCacheManager

securityManager.cacheManager = $cacheManager
"""

  val realm: LdapGroupRealm = {
    val ini = {
      val tmp = new Ini()
      tmp.load(IniConfig)
      tmp
    }
    val factory = new IniSecurityManagerFactory(ini)

    val sManager = factory.getInstance()
    SecurityUtils.setSecurityManager(sManager)

    val realms = sManager match {
      case sm: DefaultSecurityManager =>
        sm.getRealms()
      case _ => throw new AssertionError("unexpected security manager type")
    }

    realms.size() should equal(1)
    val realm: Realm = realms.iterator().next()
    realm match {
      case r: LdapGroupRealm =>
        r
      case _ => throw new AssertionError("unexpected realm type")
    }
  }

  describe("LdapGroupRealm") {
    it("should extract search base from ini file") {
      realm.searchBase should equal("dc=xxx,dc=org")
    }

    it("should extract allowed groups from ini file") {
      realm.allowedGroups.get should equal(Array("cn=group1,ou=groups", "cn=group2,ou=groups"))
    }

    it("should retrieve group names") {
      realm.retrieveGroups(new TestLdapContext()).keys should equal(Set("cn=group1,ou=groups", "cn=group2,ou=groups", "cn=groupXX,ou=groups"))
    }

    it("should return role names for test user in group 1") {
      realm.getRoleNamesForUser(new TestLdapContext(), "userInGroup1") should equal(Set("cn=group1,ou=groups"))
    }

    it("should return role names for test user in group 2") {
      realm.getRoleNamesForUser(new TestLdapContext(), "userInGroup2") should equal(Set("cn=group2,ou=groups"))
    }

    it("should return role names for test user in group XX") {
      //groupXX is not one of the allowed groups, but still a group
      realm.getRoleNamesForUser(new TestLdapContext(), "userInGroupXX") should equal(Set("cn=groupXX,ou=groups"))
    }

    it("should return no role names for unknown test user ") {
      realm.getRoleNamesForUser(new TestLdapContext(), "userInNoGroup") should equal(Set())
    }

    it("should allow login of test user in group 1") {
      realm.queryForAuthorizationInfo(new TestLdapContext(), "userInGroup1").getRoles should equal(new SimpleAuthorizationInfo(Set("cn=group1,ou=groups").asJava).getRoles)
    }

    it("should allow login of test user in group 2") {
      realm.queryForAuthorizationInfo(new TestLdapContext(), "userInGroup2").getRoles should equal(new SimpleAuthorizationInfo(Set("cn=group2,ou=groups").asJava).getRoles)
    }

    it("should not allow login for test user from wrong group") {
      val thrown = the[RuntimeException] thrownBy realm.queryForAuthorizationInfo(new TestLdapContext(), "userInGroupXX")
      thrown.getMessage should equal(LdapGroupRealm.ERROR_MSG_NO_VALID_GROUP)
    }

    it("should not allow login for unknown test user ") {
      val thrown = the[RuntimeException] thrownBy realm.queryForAuthorizationInfo(new TestLdapContext(), "userInNoGroup")
      thrown.getMessage should equal(LdapGroupRealm.ERROR_MSG_NO_VALID_GROUP)
    }

  }
}

class TestLdapContext extends LdapContext {
  // Members declared in Context
  def addToEnvironment(x$1: String, x$2: Any): Object = ???
  def bind(x$1: String, x$2: Any): Unit = ???
  def bind(x$1: Name, x$2: Any): Unit = ???
  def close(): Unit = ???
  def composeName(x$1: String, x$2: String): String = ???
  def composeName(x$1: Name, x$2: Name): Name = ???
  def createSubcontext(x$1: String): Context = ???
  def createSubcontext(x$1: Name): Context = ???
  def destroySubcontext(x$1: String): Unit = ???
  def destroySubcontext(x$1: Name): Unit = ???
  def getEnvironment(): java.util.Hashtable[_, _] = ???
  def getNameInNamespace(): String = ???
  def getNameParser(x$1: String): NameParser = ???
  def getNameParser(x$1: Name): NameParser = ???
  def list(x$1: String): NamingEnumeration[NameClassPair] = ???
  def list(x$1: Name): NamingEnumeration[NameClassPair] = ???
  def listBindings(x$1: String): NamingEnumeration[Binding] = ???
  def listBindings(x$1: Name): NamingEnumeration[Binding] = ???
  def lookup(x$1: String): Object = ???
  def lookup(x$1: Name): Object = ???
  def lookupLink(x$1: String): Object = ???
  def lookupLink(x$1: Name): Object = ???
  def rebind(x$1: String, x$2: Any): Unit = ???
  def rebind(x$1: Name, x$2: Any): Unit = ???
  def removeFromEnvironment(x$1: String): Object = ???
  def rename(x$1: String, x$2: String): Unit = ???
  def rename(x$1: Name, x$2: Name): Unit = ???
  def unbind(x$1: String): Unit = ???
  def unbind(x$1: Name): Unit = ???

  // Members declared in directory.DirContext
  def bind(x$1: String, x$2: Any, x$3: directory.Attributes): Unit = ???
  def bind(x$1: Name, x$2: Any, x$3: directory.Attributes): Unit = ???
  def createSubcontext(x$1: String, x$2: directory.Attributes): directory.DirContext = ???
  def createSubcontext(x$1: Name, x$2: directory.Attributes): directory.DirContext = ???
  def getAttributes(x$1: String, x$2: Array[String]): directory.Attributes = ???
  def getAttributes(x$1: Name, x$2: Array[String]): directory.Attributes = ???
  def getAttributes(x$1: String): directory.Attributes = ???
  def getAttributes(x$1: Name): directory.Attributes = ???
  def getSchema(x$1: String): directory.DirContext = ???
  def getSchema(x$1: Name): directory.DirContext = ???
  def getSchemaClassDefinition(x$1: String): directory.DirContext = ???
  def getSchemaClassDefinition(x$1: Name): directory.DirContext = ???
  def modifyAttributes(x$1: String, x$2: Array[directory.ModificationItem]): Unit = ???
  def modifyAttributes(x$1: Name, x$2: Array[directory.ModificationItem]): Unit = ???
  def modifyAttributes(x$1: String, x$2: Int, x$3: directory.Attributes): Unit = ???
  def modifyAttributes(x$1: Name, x$2: Int, x$3: directory.Attributes): Unit = ???
  def rebind(x$1: String, x$2: Any, x$3: directory.Attributes): Unit = ???
  def rebind(x$1: Name, x$2: Any, x$3: directory.Attributes): Unit = ???

  def search(searchBase: String, searchFilter: String, searchAtts: Array[Object], searchCtls: SearchControls): NamingEnumeration[SearchResult] = {
    if (searchFilter == LdapGroupRealm.groupMemberFilter) {
      new TestNamingEnumeration(List(new SearchResult("cn=group1,ou=groups", null, new BasicAttributes("member", "cn=userInGroup1,ou=people,dc=xxx,dc=org")),
        new SearchResult("cn=group2,ou=groups", null, new BasicAttributes("member", "cn=userInGroup2,ou=people,dc=xxx,dc=org")),
        new SearchResult("cn=groupXX,ou=groups", null, new BasicAttributes("member", "cn=userInGroupXX,ou=people,dc=xxx,dc=org"))))
    } else {
      new TestNamingEnumeration(List(new SearchResult("cn=%s,ou=people" format searchAtts(0), null, new BasicAttributes("k", "v"))))
    }
  }

  def search(x$1: Name, x$2: String, x$3: Array[Object], x$4: directory.SearchControls): NamingEnumeration[directory.SearchResult] = ???
  def search(x$1: String, x$2: String, x$3: directory.SearchControls): NamingEnumeration[directory.SearchResult] = ???

  def search(x$1: Name, x$2: String, x$3: directory.SearchControls): NamingEnumeration[directory.SearchResult] = ???
  def search(x$1: String, x$2: directory.Attributes): NamingEnumeration[directory.SearchResult] = ???
  def search(x$1: Name, x$2: directory.Attributes): NamingEnumeration[directory.SearchResult] = ???
  def search(x$1: String, x$2: directory.Attributes, x$3: Array[String]): NamingEnumeration[directory.SearchResult] = ???
  def search(x$1: Name, x$2: directory.Attributes, x$3: Array[String]): NamingEnumeration[directory.SearchResult] = ???
  // Members declared in ldap.LdapContext
  def extendedOperation(x$1: ldap.ExtendedRequest): ldap.ExtendedResponse = ???
  def getConnectControls(): Array[ldap.Control] = ???
  def getRequestControls(): Array[ldap.Control] = ???
  def getResponseControls(): Array[ldap.Control] = ???
  def newInstance(x$1: Array[ldap.Control]): ldap.LdapContext = ???
  def reconnect(x$1: Array[ldap.Control]): Unit = ???
  def setRequestControls(x$1: Array[ldap.Control]): Unit = ???
}

class TestNamingEnumeration(members: List[SearchResult]) extends NamingEnumeration[SearchResult] {
  var ix = 0
  def hasMoreElements(): Boolean = hasMore
  def nextElement(): directory.SearchResult = next

  // Members declared in javax.naming.NamingEnumeration
  def close(): Unit = {}
  def hasMore(): Boolean = ix < members.size
  def next(): directory.SearchResult = {
    ix = ix + 1
    members(ix - 1)
  }
}
