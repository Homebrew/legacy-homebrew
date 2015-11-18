class ImatixGsl < Formula
  desc "iMatix GSL code generator"
  homepage "https://github.com/imatix/gsl"
  head "https://github.com/imatix/gsl.git"

  def install
    cd "src" do
      system "make"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end

  test do
    script_name = "hello_world.gsl"
    output_name = "hello_world.txt"
    script = <<-GSL
.output "#{output_name}"
.who = "world"
>Hello $(who)!
    GSL
    output = "Hello world!\n"

    (testpath/script_name).write(script)
    system bin/"gsl", testpath/script_name
    assert_equal output, (testpath/output_name).read
  end
end
