package ooyala.common.akka.web

import org.joda.time.DateTime
import org.scalatest.{Matchers, FunSpec}
import spray.json.JsonParser.ParsingException

class JsonUtilsSpec extends FunSpec with Matchers {
  import spray.json._
  import spray.json.DefaultJsonProtocol._

  val Dt1 = "2012-09-09T04:18:13.001Z"
  val Dt2 = "2012-09-09T04:18:13.002Z"

  describe("JSON conversion") {
    it("should generate proper JSON for list of maps") {
      val batch = Seq(Map(Dt1 -> Map("ipaddr" -> "1.2.3.4")),
                      Map(Dt2 -> Map("guid" -> "xyz")))
      val expected = """[{"2012-09-09T04:18:13.001Z":{"ipaddr":"1.2.3.4"}},""" +
                     """{"2012-09-09T04:18:13.002Z":{"guid":"xyz"}}]"""
      JsonUtils.listToJson(batch) should equal (expected)
    }

    it("should generate map from JSON") {
      val json = """[{"2012-09-09T04:18:13.002Z":{"ipaddr":"1.2.3.5"}},
                     {"2012-09-09T04:18:13.001Z":{"guid":"abc"}}]"""
      val batch = Seq(Map(Dt2 -> Map("ipaddr" -> "1.2.3.5")),
                      Map(Dt1 -> Map("guid" -> "abc")))
      JsonUtils.listFromJson(json) should equal (batch)
    }

    it("should serialize an empty map to JSON") {
      val expected = """{}"""
      import JsonUtils._
      Map[String, Any]().toJson.compactPrint should equal (expected)
    }

    it("should serialize first-level empty maps to JSON") {
      val expected = """{"a":1,"b":{}}"""
      import JsonUtils._
      Map("a" -> 1, "b" -> Map.empty).toJson.compactPrint should equal (expected)
    }

    it("should serialize second-level empty maps to JSON") {
      val expected = """{"a":1,"b":{"a1":1,"b1":{}}}"""
      import JsonUtils._
      Map("a" -> 1, "b" -> Map("a1" -> 1, "b1" -> Map.empty)).toJson.compactPrint should equal (expected)
    }

    it("should serialize third-level empty maps to JSON") {
      val expected = """{"a":1,"b":{"a1":1,"b1":{"a2":1,"b2":{}}}}"""
      import JsonUtils._
      Map("a" -> 1, "b" -> Map("a1" -> 1, "b1" -> Map("a2" -> 1, "b2" -> Map.empty))).toJson.compactPrint should equal (expected)
    }

    it("should serialize some other types") {
      val expected1 = """{"1":[1,2,3]}"""
      import JsonUtils._
      Map("1" -> Array(1, 2, 3): (String, Any)).toJson.compactPrint should equal (expected1)

      val expected2 = """{"1":[1,2,"b"]}"""
      Map("1" -> (1, 2, "b")).toJson.compactPrint should equal (expected2)
    }

    it("should serialize unknown types to their string representations") {
      val expected = "[1,2,\"" + Dt1 + "\"]"
      import JsonUtils._
      Seq(1, 2, DateTime.parse(Dt1)).toJson.compactPrint should equal (expected)
    }

    it("should throw exception for invalid JSON") {
      val badJson1 = """{123: 456}"""    // objects must have string keys
      val badJson2 = """["abc]"""         // unbalanced quotes
      intercept[ParsingException](JsonUtils.listFromJson(badJson1))
      intercept[ParsingException](JsonUtils.listFromJson(badJson2))
      intercept[ParsingException](JsonUtils.mapFromJson(badJson1))
      intercept[ParsingException](JsonUtils.mapFromJson(badJson2))
    }

    it("should throw exception for valid JSON that doesn't conform to expected type") {
      intercept[DeserializationException](JsonUtils.listFromJson("""{"1": 2}"""))
      intercept[DeserializationException](JsonUtils.mapFromJson("""["123"]"""))
    }
  }
}
