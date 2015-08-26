class Supersonic < Formula
  desc "C++ library providing a column oriented query engine"
  homepage "https://code.google.com/p/supersonic/"
  url "https://supersonic.googlecode.com/files/supersonic-0.9.4.tar.gz"
  sha256 "1592dfd2dc73f0b97298e0d25e51528dc9a94e9e7f4ab525569f63db0442d769"

  bottle do
    revision 1
    sha256 "75c8903d7d637aa495c83eb3a3569b627fbdf9799e907a7d0fff536cf3ddb155" => :yosemite
    sha256 "c72cb21c7f1efc5a790be376e55dcc4a1edc76cda6686c2ba7d3d7f8c2937321" => :mavericks
    sha256 "2869dba7bb685f7f6e4df504b87e01a7dda685afc3f27fa1c6010c150982317f" => :mountain_lion
  end

  if MacOS.version < :mavericks
    depends_on "protobuf" => "c++11"
    depends_on "boost" => "c++11"
  else
    depends_on "protobuf"
    depends_on "boost"
  end

  depends_on "pkg-config" => :build
  depends_on "glog"

  needs :cxx11

  def install
    ENV.cxx11

    # gflags no longer supply .pc files; supersonic's compile expects them.
    ENV["GFLAGS_CFLAGS"] = "-I#{Formula["gflags"].opt_include}"
    ENV["GFLAGS_LIBS"] = "-L#{Formula["gflags"].opt_lib} -lgflags"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-re2"
    system "make", "clean"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <supersonic/supersonic.h>
      using std::cout;
      using std::endl;
      using supersonic::BoundExpressionTree;
      using supersonic::Expression;
      using supersonic::Plus;
      using supersonic::AttributeAt;
      using supersonic::TupleSchema;
      using supersonic::Attribute;
      using supersonic::INT32;
      using supersonic::NOT_NULLABLE;
      using supersonic::FailureOrOwned;
      using supersonic::HeapBufferAllocator;
      using supersonic::View;
      using supersonic::EvaluationResult;
      using supersonic::SingleSourceProjector;

      BoundExpressionTree* PrepareBoundexpression_r() {
          scoped_ptr<const Expression> addition(Plus(AttributeAt(0), AttributeAt(1)));
          TupleSchema schema;
          schema.add_attribute(Attribute("a", INT32, NOT_NULLABLE));
          schema.add_attribute(Attribute("b", INT32, NOT_NULLABLE));
          FailureOrOwned<BoundExpressionTree> bound_addition =
              addition->Bind(schema, HeapBufferAllocator::Get(), 2048);

          if(bound_addition.is_success()) {
              return bound_addition.release();
          }

          return NULL;
      }

      const int32* AddColumns(int32* a, int32* b, size_t row_count, BoundExpressionTree* bound_tree) {
          TupleSchema schema;
          schema.add_attribute(Attribute("a", INT32, NOT_NULLABLE));
          schema.add_attribute(Attribute("b", INT32, NOT_NULLABLE));
          View input_view(schema);
          input_view.set_row_count(row_count);
          input_view.mutable_column(0)->Reset(a, NULL);
          input_view.mutable_column(1)->Reset(b, NULL);
          EvaluationResult result = bound_tree->Evaluate(input_view);
          if(result.is_success()) {
              cout << "Column Count : " << result.get().column_count() <<
                  " and Row Count" << result.get().row_count() << endl;
              return result.get().column(0).typed_data<INT32>();
          }

          return NULL;
      }

      int main(void) {
          int32 a[8] = {0, 1, 2, 3,  4, 5, 6,  7};
          int32 b[8] = {3, 4, 6, 8,  1, 2, 2,  9};

          scoped_ptr<BoundExpressionTree> expr(PrepareBoundexpression_r());
          const int32* result = AddColumns(a, b, 8, expr.get());

          if(result == NULL) {
              cout << "Failed to execute the addition operation!" << endl;
          }

          cout << "Results: ";
          for(int i = 0; i < 8; i++) {
              cout << result[i] << " ";
          }

          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-stdlib=libc++", "-lsupersonic", "-lglog", "-lprotobuf", "-lboost_system", "-o", "test"
    system "./test"
  end
end
