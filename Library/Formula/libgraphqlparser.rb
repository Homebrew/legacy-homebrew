class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.2.0.tar.gz"
  sha256 "5064f63024c20cdc2c41970a6e9a5c7b053565db22f5f8dfb946923cb077f9de"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    require "json"

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

    test_ast = JSON.parse(pipe_output("#{libexec}/dump_json_ast", sample_query))
    assert_equal sample_ast, test_ast
  end
end
