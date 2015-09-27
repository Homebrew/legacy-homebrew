require "open3"

class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.1.0.tar.gz"
  sha256 "e4a12bba2f6c2db1b0528db5a0a3283fc5380ac5cadb8036793054cb7c9dd3ad"

  depends_on "cmake" => :build
  depends_on "bison" => :recommended
  depends_on "flex"  => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "dump_json_ast"
    lib.install "libgraphqlparser.dylib"
  end

  test do
    SAMPLE_QUERY = <<-QUERY
{
  user(id: 1) {
    name
    age
    friends {
      name
    }
  }
}
    QUERY

    SAMPLE_AST = <<-AST
{"kind":"Document","loc":{"start":1,"end":2},"definitions":[{"kind":"OperationDefinition","loc":{"start":1,"end":2},"operation":"query","name": null,"variableDefinitions":null,"directives":null,"selectionSet":{"kind":"SelectionSet","loc":{"start":1,"end":2},"selections":[{"kind":"Field","loc":{"start":3,"end":4},"alias":null,"name":{"kind":"Name","loc":{"start":3,"end":7},"value":"user"},"arguments":[{"kind":"Argument","loc":{"start":8,"end":13},"name":{"kind":"Name","loc":{"start":8,"end":10},"value":"id"},"value":{"kind":"IntValue","loc":{"start":12,"end":13},"value":"1"}}],"directives":null,"selectionSet":{"kind":"SelectionSet","loc":{"start":15,"end":4},"selections":[{"kind":"Field","loc":{"start":5,"end":9},"alias":null,"name":{"kind":"Name","loc":{"start":5,"end":9},"value":"name"},"arguments":null,"directives":null,"selectionSet":null},{"kind":"Field","loc":{"start":5,"end":8},"alias":null,"name":{"kind":"Name","loc":{"start":5,"end":8},"value":"age"},"arguments":null,"directives":null,"selectionSet":null},{"kind":"Field","loc":{"start":5,"end":6},"alias":null,"name":{"kind":"Name","loc":{"start":5,"end":12},"value":"friends"},"arguments":null,"directives":null,"selectionSet":{"kind":"SelectionSet","loc":{"start":13,"end":6},"selections":[{"kind":"Field","loc":{"start":7,"end":11},"alias":null,"name":{"kind":"Name","loc":{"start":7,"end":11},"value":"name"},"arguments":null,"directives":null,"selectionSet":null}]}}]}}]}}]}
    AST

    Open3.capture2("dump_json_ast", :stdin_data => SAMPLE_QUERY).first == SAMPLE_AST
  end
end
