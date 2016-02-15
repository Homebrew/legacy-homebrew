class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.4.0.tar.gz"
  sha256 "cebcc80cc6de038b8f5da4e8882761377d251d81cb19a21e67142500522c0af2"

  bottle do
    cellar :any
    sha256 "3abc582d43fa23c0f4f68eeda3fa6f881140dc0a425c92b63611a144a8dd1273" => :el_capitan
    sha256 "a90e07b576f5b49cc1cab62d00ad5db77edef5068e2d8bea78a6243452756443" => :yosemite
    sha256 "d0b4915048f6e082e2c16ea32ee92581f7d1fe25f5aff6d04026160801ba1ec1" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    require "utils/json"

    sample_query = <<-EOS.undent
      { user }
    EOS

    sample_ast = { "kind"=>"Document",
                   "loc"=>{ "start"=>1, "end"=>9 },
                   "definitions"=>
        [{ "kind"=>"OperationDefinition",
           "loc"=>{ "start"=>1, "end"=>9 },
           "operation"=>"query",
           "name"=>nil,
           "variableDefinitions"=>nil,
           "directives"=>nil,
           "selectionSet"=>
           { "kind"=>"SelectionSet",
             "loc"=>{ "start"=>1, "end"=>9 },
             "selections"=>
             [{ "kind"=>"Field",
                "loc"=>{ "start"=>3, "end"=>7 },
                "alias"=>nil,
                "name"=>
                { "kind"=>"Name", "loc"=>{ "start"=>3, "end"=>7 }, "value"=>"user" },
                "arguments"=>nil,
                "directives"=>nil,
                "selectionSet"=>nil, }], }, }], }

    test_ast = Utils::JSON.load pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
