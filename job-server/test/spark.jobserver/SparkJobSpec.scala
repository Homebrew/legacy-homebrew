package spark.jobserver

import org.scalatest.FunSpec
import org.scalatest.matchers.ShouldMatchers

class SparkJobSpec extends FunSpec with ShouldMatchers{
  val validSparkValidation = SparkJobValid
  val invalidSparkValidation = SparkJobInvalid("Sample message 1")
  val invalidSparkValidation2 = SparkJobInvalid("Sample message 2")

  describe("Sample tests for default validation && method") {
    it("should return valid") {
      validSparkValidation && (validSparkValidation) should equal (SparkJobValid)
    }

    it("should return invalid if one of them is invalid") {
      validSparkValidation && (invalidSparkValidation) should equal (SparkJobInvalid("Sample message 1"))
    }

    it ("should return invalid if both of them are invalid with the first message") {
      invalidSparkValidation2 && (invalidSparkValidation) should equal (SparkJobInvalid("Sample message 2"))
    }
  }
}
