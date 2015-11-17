class ImatixGsl < Formula
  desc "iMatix GSL code generator"
  homepage "https://github.com/imatix/gsl"
  head "https://github.com/imatix/gsl.git"

  def install
    cd "src" do
      system "make"
      system "make", "install"
    end
  end

  TEST_SCRIPT_NAME = "hello_world.gsl"
  TEST_OUTPUT_NAME = "hello_world.txt"
  TEST_SCRIPT = <<-GSL
.output "#{TEST_OUTPUT_NAME}"
.who = "world"
>Hello $(who)!
    GSL
  TEST_OUTPUT = "Hello world!\n"

  test do
    (testpath/TEST_SCRIPT_NAME).write(TEST_SCRIPT)
    system bin/"gsl", testpath/TEST_SCRIPT_NAME
    assert_equal TEST_OUTPUT, (testpath/TEST_OUTPUT_NAME).read
  end
end
