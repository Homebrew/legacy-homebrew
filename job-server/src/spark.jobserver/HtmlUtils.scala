package spark.jobserver

import spark.jobserver.io.JobInfo
import org.joda.time.{ Duration, DateTime }
import scala.xml.Elem

object HtmlUtils {
  def pageTemplate(body: Seq[Elem]): Elem =
    <html>
      <head><title>Spark Job Server</title></head>
      <body>
        { body }
      </body>
    </html>

  def jobsList(title: String, jobs: Seq[JobInfo]): Elem =
    pageTemplate(
      Seq(
        <h1>{ title }</h1>,
        <table border="1">
          <tr>
            <th>ClassName</th>
            <th>Elapsed (secs)</th>
          </tr>
          {
            jobs map { job =>
              <tr>
                <td>
                  { job.classPath }
                </td>
                <td align="right">
                  { (new Duration(job.startTime, DateTime.now).getMillis / 1000).toString }
                </td>
              </tr>
            }
          }
        </table>))
}
