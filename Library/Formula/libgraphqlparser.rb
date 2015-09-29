require "open3"
require "json"

class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.2.0.tar.gz"
  sha256 "5064f63024c20cdc2c41970a6e9a5c7b053565db22f5f8dfb946923cb077f9de"

  depends_on "cmake" => :build
  depends_on "bison" => :recommended
  depends_on "flex"  => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    sample_query = <<-EOS.undent
      {
        user(id: 1) {
          name
          age
          friends {
            name
          }
        }
      }
    EOS

    sample_ast = {
      "kind" => "Document",
      "loc" => {
        "start" => 1,
        "end" => 2,
      },
      "definitions" => [
        {
          "kind" => "OperationDefinition",
          "loc" => {
            "start" => 1,
            "end" => 2,
          },
          "operation" => "query",
          "name" => nil,
          "variableDefinitions" => nil,
          "directives" => nil,
          "selectionSet" => {
            "kind" => "SelectionSet",
            "loc" => {
              "start" => 1,
              "end" => 2,
            },
            "selections" => [
              {
                "kind" => "Field",
                "loc" => {
                  "start" => 3,
                  "end" => 4,
                },
                "alias" => nil,
                "name" => {
                  "kind" => "Name",
                  "loc" => {
                    "start" => 3,
                    "end" => 7,
                  },
                  "value" => "user",
                },
                "arguments" => [
                  {
                    "kind" => "Argument",
                    "loc" => {
                      "start" => 8,
                      "end" => 13,
                    },
                    "name" => {
                      "kind" => "Name",
                      "loc" => {
                        "start" => 8,
                        "end" => 10,
                      },
                      "value" => "id",
                    },
                    "value" => {
                      "kind" => "IntValue",
                      "loc" => {
                        "start" => 12,
                        "end" => 13,
                      },
                      "value" => "1",
                    },
                  }
                ],
                "directives" => nil,
                "selectionSet" => {
                  "kind" => "SelectionSet",
                  "loc" => {
                    "start" => 15,
                    "end" => 4,
                  },
                  "selections" => [
                    {
                      "kind" => "Field",
                      "loc" => {
                        "start" => 5,
                        "end" => 9,
                      },
                      "alias" => nil,
                      "name" => {
                        "kind" => "Name",
                        "loc" => {
                          "start" => 5,
                          "end" => 9,
                        },
                        "value" => "name",
                      },
                      "arguments" => nil,
                      "directives" => nil,
                      "selectionSet" => nil,
                    },
                    {
                      "kind" => "Field",
                      "loc" => {
                        "start" => 5,
                        "end" => 8,
                      },
                      "alias" => nil,
                      "name" => {
                        "kind" => "Name",
                        "loc" => {
                          "start" => 5,
                          "end" => 8,
                        },
                        "value" => "age",
                      },
                      "arguments" => nil,
                      "directives" => nil,
                      "selectionSet" => nil,
                    },
                    {
                      "kind" => "Field",
                      "loc" => {
                        "start" => 5,
                        "end" => 6,
                      },
                      "alias" => nil,
                      "name" => {
                        "kind" => "Name",
                        "loc" => {
                          "start" => 5,
                          "end" => 12,
                        },
                        "value" => "friends",
                      },
                      "arguments" => nil,
                      "directives" => nil,
                      "selectionSet" => {
                        "kind" => "SelectionSet",
                        "loc" => {
                          "start" => 13,
                          "end" => 6,
                        },
                        "selections" => [
                          {
                            "kind" => "Field",
                            "loc" => {
                              "start" => 7,
                              "end" => 11,
                            },
                            "alias" => nil,
                            "name" => {
                              "kind" => "Name",
                              "loc" => {
                                "start" => 7,
                                "end" => 11,
                              },
                              "value" => "name",
                            },
                            "arguments" => nil,
                            "directives" => nil,
                            "selectionSet" => nil,
                          }
                        ],
                      },
                    },
                  ],
                },
              }
            ],
          },
        }
      ],
    }

    test_ast = JSON.parse(pipe_output("#{libexec}/dump_json_ast", sample_query))

    assert_equal sample_ast, test_ast
  end
end
