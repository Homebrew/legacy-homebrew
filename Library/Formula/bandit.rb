class Bandit < Formula
  desc "Human friendly unit testing for C++11"
  homepage "http://banditcpp.org"
  url "https://github.com/joakimkarlsson/bandit/archive/v2.0.0.tar.gz"
  sha256 "e86b7c60753d828149a42298152f807c8020f9905f410acb9e45d87f4ea22a5e"

  resource "snowhouse" do
    url "https://github.com/joakimkarlsson/snowhouse/archive/v2.1.0.tar.gz"
    sha256 "bb7f7945698eacd8c348aac5eefc782fe64e5d22a867820d668060df0b132fda"
  end

  def install
    include.install "bandit"
    resource("snowhouse").stage do
      (include/"bandit/assertion_frameworks/snowhouse").install "snowhouse"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <bandit/bandit.h>
      using namespace bandit;
      go_bandit([](){
        describe("a feature", [](){
          it("make something", [&](){
            AssertThat(true, IsTrue());
            AssertThat(123, Equals(123));
            AssertThat("a string", Equals("a string"));
          });
        });
      });

      int main(int argc, char **argv) {
        return bandit::run(argc, argv);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
