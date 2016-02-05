class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/v0.4.0.tar.gz"
  sha256 "cebcc80cc6de038b8f5da4e8882761377d251d81cb19a21e67142500522c0af2"

  bottle do
    cellar :any
    sha256 "a3159b88fa2731edc6e8b36f903f999717fcc0eae25cd943166d4ca8818cd82f" => :el_capitan
    sha256 "bcd9fa1158621ff40007ab047acd90cd20f60827c7f584b1e1d81065ae1a9efc" => :yosemite
    sha256 "9d39dfd27728ff7904dc09a02c854bc4c85f43a34c9e6a9d17506df2e883cd66" => :mavericks
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
