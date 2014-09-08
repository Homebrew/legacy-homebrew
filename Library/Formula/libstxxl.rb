require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.0/stxxl-1.4.0.tar.gz'
  sha1 'a7001e7f04904be2bad9e80aa360528768a2068a'

  bottle do
    cellar :any
    revision 1
    sha1 "70e197e4e512dcff744ab87f14aa836c5696282b" => :mavericks
    sha1 "69e3a7f785ad320c9e90c1bf376f69c6019c42a2" => :mountain_lion
    sha1 "7330221970a6eb9b271d85ca7a9ebe6328d6da24" => :lion
  end

  depends_on 'cmake' => :build

  # all patches can be removed with a new upstream release
  # compile fixes for OS X 10.7 and 10.8 as discussed
  patch do
    url "https://github.com/stxxl/stxxl/commit/d23dd29b9492061a8da2201ab2585914b66bb9c3.diff"
    sha1 "af0e84a74f20047def5a76146057f3c176f12845"
  end
  # uncrustify older modification in unique_ptr.h
  patch do
    url "https://github.com/stxxl/stxxl/commit/014eccfb640602de7be085670d6ac251663e3934.diff"
    sha1 "7fc9c045c8939a81694072280058c5efb4d639cb"
  end
  # adding binary_buffer and binary_reader for in-memory serialization
  patch do
    url "https://github.com/stxxl/stxxl/commit/4a5305d360199693707322c920ab68a0e09beba8.diff"
    sha1 "e3f1f35746caef3d45d85048ee4a7d243f3b6590"
  end
  # extended test_vector_buf test case to check writing to empty vector
  patch do
    url "https://github.com/stxxl/stxxl/commit/08ea799de263fcd235eb1a4b7151d7feb1f36acb.diff"
    sha1 "183b03d460e673a289dfbb920e017e43b1a98183"
  end
  # changed only some of cmakelint's warnings
  patch do
    url "https://github.com/stxxl/stxxl/commit/590726a202cd21d56e1b9fe902a7b6a4b6ba0896.diff"
    sha1 "93abf0db1c5d5c4b55f86377d809b547df742d5b"
  end
  # fixing occurrances for atoint64 in older programs. atoint64 was renamed to atouint64, which is what it does
  patch do
    url "https://github.com/stxxl/stxxl/commit/c92521a91aedb950d57cd7e0f596cc622f2e67c8.diff"
    sha1 "a4be262a09e277a136fb9565ca1e8043647c829c"
  end
  # adding --block_size parameter to benchmark_disks stxxl_tool subprogram
  patch do
    url "https://github.com/stxxl/stxxl/commit/f3c3cc1563cd179d114a73333e426bd8c817754f.diff"
    sha1 "79e1addec69cf6f6e87789e67d7f27b22a713553"
  end
  # rewriting adaptor.h: removing register keyword and fixing illegal variable names
  patch do
    url "https://github.com/stxxl/stxxl/commit/9d673f67328b2f5a4d53f036c70cbcc44610452c.diff"
    sha1 "72e453563041617aa79a99267cab25e4eab7bb96"
  end
  # adding -stdlib=libc++ on MacOSX when compiling with clang
  patch do
    url "https://github.com/stxxl/stxxl/commit/40361d83389234d05499be30fcddc2b6bd64e967.diff"
    sha1 "e051fa9a8354faf3741d4a60374238715831a721"
  end

  def install
    args = std_cmake_args - %w{-DCMAKE_BUILD_TYPE=None}
    args << "-DCMAKE_BUILD_TYPE=Release"
    mkdir "build" do
      system "cmake", "..", *args
      system 'make install'
    end
  end
end
