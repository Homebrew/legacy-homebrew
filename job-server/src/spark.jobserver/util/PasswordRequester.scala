package spark.jobserver.util

object PasswordRequester {
  def requestPassword(aPrompt: String): Array[Char] = {
    val console = System.console()
    if (console != null) {
      print(aPrompt)
      console.readPassword()
    } else {
      //TODO - this is really, really tricky without a console.
      "changeit".toCharArray
    }
  }
}
