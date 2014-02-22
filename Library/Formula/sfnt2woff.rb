require "formula"
require "digest"

class Sfnt2woff < Formula
  homepage "https://github.com/ppicazo/sfnt2woff"
  url "https://github.com/ppicazo/sfnt2woff/archive/1.0.tar.gz"
  sha1 "1707f3a1b16339fe5b5c4431d4988e628c184832"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  test do
    # Very basic test that sfnt2woff and woff2sfnt built and installed properly, but not much more

    # Known 'good' test files
    original_otf, original_otf_md5 = "AdobeBlank.otf.original", "a0db4b06930013ca015655b993f68766"
    original_woff, original_woff_md5 = "AdobeBlank.woff.original", "5328b059986077a175779900d3b715c3"

    system "curl", "-o", original_otf, "http://ppicazo.github.io/sfnt2woff/test_files/AdobeBlank.otf"
    system "curl", "-o", original_woff, "http://ppicazo.github.io/sfnt2woff/test_files/AdobeBlank.otf.woff"

    # Test 1: passing an otf through both executables should result in the same file
    test1_sfnt2woff_result = "AdobeBlank.otf.original.woff"
    test1_woff2sfnt_result = "test1.otf"

    system "#{bin}/sfnt2woff #{original_otf}"
    assert_equal original_woff_md5, Digest::MD5.file(test1_sfnt2woff_result).to_s, "Output of sfnt2woff should match the downloaded woff."
    system "#{bin}/woff2sfnt #{test1_sfnt2woff_result} > #{test1_woff2sfnt_result}"
    assert_equal original_otf_md5, Digest::MD5.file(test1_woff2sfnt_result).to_s, "Output of woff2sfnt should match the downloaded otf."

    # Test 2: the woff downloaded and passed through woff2sfnt should be the same otf as we downloaded
    test2_woff2sfnt_result = "test2.otf"

    system "#{bin}/woff2sfnt #{original_woff} > #{test2_woff2sfnt_result}"
    assert_equal original_otf_md5, Digest::MD5.file(test2_woff2sfnt_result).to_s, "Output of woff2sfnt using the downloaded woff should match the downloaded otf."
  end
end
