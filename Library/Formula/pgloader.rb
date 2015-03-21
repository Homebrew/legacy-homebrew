require "formula"

class Pgloader < Formula
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.2.0.tar.gz"
  sha1 "4f80e64d056f2ddb43389211fbe061d5163e80fe"
  head "https://github.com/dimitri/pgloader.git"

  depends_on "sbcl"
  depends_on "freetds"
  depends_on "buildapp" => :build


  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "http://beta.quicklisp.org/archive/alexandria/2014-08-26/alexandria-20140826-git.tgz"
    sha1 "00d1941a2fd4c941c61c6f42665ff10dbad0ad30"
  end

  resource "anaphora" do
    url "http://beta.quicklisp.org/archive/anaphora/2011-06-19/anaphora-0.9.4.tgz"
    sha1 "1e9faa00efff11b45ca7bed64a1fb60e9ce55dbd"
  end

  resource "asdf-finalizers" do
    url "http://beta.quicklisp.org/archive/asdf-finalizers/2014-08-26/asdf-finalizers-20140826-git.tgz"
    sha1 "493c5734c8f7444ac7194feeb54bd6a98b397929"
  end

  resource "asdf-system-connections" do
    url "http://beta.quicklisp.org/archive/asdf-system-connections/2014-02-11/asdf-system-connections-20140211-git.tgz"
    sha1 "212ab6d6e591c106ebab26e000a9cf6cf41d3022"
  end

  resource "babel" do
    url "http://beta.quicklisp.org/archive/babel/2014-12-17/babel-20141217-git.tgz"
    sha1 "4e913ea0738682fd20cb2a8f364ba2dfb2de8965"
  end

  resource "bordeaux-threads" do
    url "http://beta.quicklisp.org/archive/bordeaux-threads/2013-06-15/bordeaux-threads-0.8.3.tgz"
    sha1 "c135e9149d524020572b08e884ebb3a2eeed50b3"
  end

  resource "cffi" do
    url "http://beta.quicklisp.org/archive/cffi/2014-11-06/cffi_0.14.0.tgz"
    sha1 "419f000e7a2a7b7c96efb64163f5db3051094ed6"
  end

  resource "chipz" do
    url "http://beta.quicklisp.org/archive/chipz/2013-01-28/chipz-20130128-git.tgz"
    sha1 "3e696fd5eda28456f68be9ea0549f55f94131e4b"
  end

  resource "chunga" do
    url "http://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz"
    sha1 "c22948b53da10ca59b356f2f65281e1e5023047f"
  end

  resource "cl+ssl" do
    url "http://beta.quicklisp.org/archive/cl+ssl/2015-03-02/cl+ssl-20150302-git.tgz"
    sha1 "4549b089a69ce1ca24d103bfb1fb7cd8a01511d5"
  end

  resource "cl-abnf" do
    url "http://beta.quicklisp.org/archive/cl-abnf/2013-12-11/cl-abnf-20131211-git.tgz"
    sha1 "5aacfda97eeb7aa26591bb87e51cff275bd41714"
  end

  resource "cl-base64" do
    url "http://beta.quicklisp.org/archive/cl-base64/2010-10-06/cl-base64-20101006-git.tgz"
    sha1 "6d41647672ae3e59e4081b580bbfc037309e254b"
  end

  resource "cl-containers" do
    url "http://beta.quicklisp.org/archive/cl-containers/2014-02-11/cl-containers-20140211-git.tgz"
    sha1 "2191a500d9a5c020018aa1150242c4f040cfc209"
  end

  resource "cl-csv" do
    url "http://beta.quicklisp.org/archive/cl-csv/2015-03-02/cl-csv-20150302-git.tgz"
    sha1 "8c2e169a45160e75db0fc9a1371187715ce95468"
  end

  resource "cl-db3" do
    url "http://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz"
    sha1 "596d5d88a8313e7691a6b8c7a773aee28a427f86"
  end

  resource "cl-fad" do
    url "http://beta.quicklisp.org/archive/cl-fad/2014-12-17/cl-fad-0.7.3.tgz"
    sha1 "3caa724473ca430824d7004790041802083b4c52"
  end

  resource "cl-interpol" do
    url "http://beta.quicklisp.org/archive/cl-interpol/2010-10-06/cl-interpol-0.2.1.tgz"
    sha1 "11df4c00076745836bb44977f6f96df931a9f1ec"
  end

  resource "cl-ixf" do
    url "http://beta.quicklisp.org/archive/cl-ixf/2014-08-26/cl-ixf-20140826-git.tgz"
    sha1 "0e43076daf3b5d31bbfecaaa39c42c79e3a293b7"
  end

  resource "cl-log" do
    url "http://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz"
    sha1 "21cf3c9457be899d72209e7eb6a6709bfd4ba680"
  end

  resource "cl-markdown" do
    url "http://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz"
    sha1 "7d5384126eeac8bd8b28ea69f06a3e36bfdb9293"
  end

  resource "cl-mssql" do
    url "http://beta.quicklisp.org/archive/cl-mssql/2013-10-03/cl-mssql-20131003-git.tgz"
    sha1 "cd3956b5c6d96d591f6e52f9773db9f53239092a"
  end

  resource "cl-ppcre" do
    url "http://beta.quicklisp.org/archive/cl-ppcre/2014-12-17/cl-ppcre-2.0.9.tgz"
    sha1 "60b2f43187dda1f05eb946116a48c9d62ba5d3bb"
  end

  resource "cl-sqlite" do
    url "http://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz"
    sha1 "7a3931643e4aa47bc5988b32001adb56f1df5232"
  end

  resource "cl-unicode" do
    url "http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz"
    sha1 "907bf3c1585d6ccf4248e517f7014747afa3193f"
  end

  resource "closer-mop" do
    url "http://beta.quicklisp.org/archive/closer-mop/2015-03-02/closer-mop-20150302-git.tgz"
    sha1 "e4c71743f9f6bb455804500244cc3b017373c88f"
  end

  resource "command-line-arguments" do
    url "http://beta.quicklisp.org/archive/command-line-arguments/2014-01-13/command-line-arguments-20140113-git.tgz"
    sha1 "b78e9692ddbd014000989f7c3862cb94b9a6c9d9"
  end

  resource "drakma" do
    url "http://beta.quicklisp.org/archive/drakma/2014-12-17/drakma-1.3.11.tgz"
    sha1 "77968e3af8ebcee0ffbb1c21b0cd29e7c427dfe5"
  end

  resource "dynamic-classes" do
    url "http://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz"
    sha1 "e433ccbeb2f82e5c228f0ecc096b42de87445665"
  end

  resource "esrap" do
    url "http://beta.quicklisp.org/archive/esrap/2015-03-02/esrap-20150302-git.tgz"
    sha1 "7296dbd45e74c907d2344a094e3d063fb1256fe3"
  end

  resource "flexi-streams" do
    url "http://beta.quicklisp.org/archive/flexi-streams/2014-12-17/flexi-streams-1.0.14.tgz"
    sha1 "b63e7cf99d7940b66e02979512ee8efb7d9566f6"
  end

  resource "garbage-pools" do
    url "http://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz"
    sha1 "dd734fe4d6fa2ac845d835ce9aaed4261440acd3"
  end

  resource "ieee-floats" do
    url "http://beta.quicklisp.org/archive/ieee-floats/2014-07-13/ieee-floats-20140713-git.tgz"
    sha1 "d64def7352ad08f23c3215e755999ba55171ea05"
  end

  resource "ironclad" do
    url "http://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz"
    sha1 "5c6c8583cd83c4c8fa9edb7fd88e2ba8ddafbb7d"
  end

  resource "iterate" do
    url "http://beta.quicklisp.org/archive/iterate/2014-07-13/iterate-20140713-darcs.tgz"
    sha1 "fa33f468672234dbd24c703f5bdeb2daa901ad8b"
  end

  resource "local-time" do
    url "http://beta.quicklisp.org/archive/local-time/2015-01-13/local-time-20150113-git.tgz"
    sha1 "eb384d031970aec6ddcda04b346d68800789a662"
  end

  resource "lparallel" do
    url "http://beta.quicklisp.org/archive/lparallel/2015-03-02/lparallel-20150302-git.tgz"
    sha1 "0edfff56a7ec5143b1d3c49fb4226a3eef651f0b"
  end

  resource "md5" do
    url "http://beta.quicklisp.org/archive/md5/2013-03-12/md5-20130312-git.tgz"
    sha1 "383e5c492ea1d6382aeb96574528c57621d23061"
  end

  resource "metabang-bind" do
    url "http://beta.quicklisp.org/archive/metabang-bind/2014-11-06/metabang-bind-20141106-git.tgz"
    sha1 "df3b04c11df749f795f6f1975f6157669186ecad"
  end

  resource "metatilities-base" do
    url "http://beta.quicklisp.org/archive/metatilities-base/2012-09-09/metatilities-base-20120909-git.tgz"
    sha1 "73bc96a3b5e61b71199fd2c58af3345545f6e027"
  end

  resource "nibbles" do
    url "http://beta.quicklisp.org/archive/nibbles/2015-03-02/nibbles-20150302-git.tgz"
    sha1 "8d68dac2f0915ac2265cd07242395851eef426d4"
  end

  resource "parse-number" do
    url "http://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz"
    sha1 "2621f8c054f706b994bea1759b01b3db312574e6"
  end

  resource "pgloader" do
    url "http://beta.quicklisp.org/archive/pgloader/2015-03-02/pgloader-3.2.0.tgz"
    sha1 "95ef9784ced9615f0aeda2a0db546eafbba72152"
  end

  resource "postmodern" do
    url "http://beta.quicklisp.org/archive/postmodern/2014-11-06/postmodern-20141106-git.tgz"
    sha1 "ae4596a9407308bc844b074032a374cdb56d0192"
  end

  resource "puri" do
    url "http://beta.quicklisp.org/archive/puri/2010-10-06/puri-20101006-git.tgz"
    sha1 "ed72ad901cd9c2ecb171692a87dc4c06956f0004"
  end

  resource "py-configparser" do
    url "http://beta.quicklisp.org/archive/py-configparser/2013-10-03/py-configparser-20131003-svn.tgz"
    sha1 "510ec60b1b60945e925fd2a821824e81db31a2e1"
  end

  resource "qmynd" do
    url "http://beta.quicklisp.org/archive/qmynd/2015-03-02/qmynd-20150302-git.tgz"
    sha1 "20b9e4dd0345fa55e4c6eb166e103e3a746e74b6"
  end

  resource "salza2" do
    url "http://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha1 "b00c72e61092e69232c2aa46b2559e093b0a8f77"
  end

  resource "split-sequence" do
    url "http://beta.quicklisp.org/archive/split-sequence/2012-07-03/split-sequence-1.1.tgz"
    sha1 "ed93b5fb609b9a04e9d1315b8ade25b5007d712e"
  end

  resource "trivial-backtrace" do
    url "http://beta.quicklisp.org/archive/trivial-backtrace/2012-09-09/trivial-backtrace-20120909-git.tgz"
    sha1 "ec0fb62c1ad44eba64db7a55b98fa81186e33e39"
  end

  resource "trivial-features" do
    url "http://beta.quicklisp.org/archive/trivial-features/2015-01-13/trivial-features-20150113-git.tgz"
    sha1 "1f887b67b31db22594e05b713f531afe7fd2e377"
  end

  resource "trivial-garbage" do
    url "http://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz"
    sha1 "ee35bca2a1668cf33bbeeeb229d5f33a0562d705"
  end

  resource "trivial-gray-streams" do
    url "http://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz"
    sha1 "1b5fa153940feacda3b6bd9f78104e310b4a4124"
  end

  resource "trivial-utf-8" do
    url "http://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha1 "c875192cc54c6101c57e6593723a84fe0498e6d9"
  end

  resource "uiop" do
    url "http://beta.quicklisp.org/archive/uiop/2014-11-06/uiop-3.1.4.tgz"
    sha1 "db611c8e74aece4716e8eb05ea58f4378cbe8de0"
  end

  resource "usocket" do
    url "http://beta.quicklisp.org/archive/usocket/2013-07-20/usocket-0.6.1.tgz"
    sha1 "7c93c389c95db51209364365bfaec53fbcec2153"
  end

  resource "uuid" do
    url "http://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz"
    sha1 "8d38cf0f436246791c243de48c6382a641450278"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"lib"/resource.name
    end

    ENV["CL_SOURCE_REGISTRY"] = "#{buildpath}/lib//"
    ENV["ASDF_OUTPUT_TRANSLATIONS"] = "/:/"
    system "make", "pgloader-standalone", "BUILDAPP=buildapp"

    bin.install "build/bin/pgloader"
    man1.install "pgloader.1"
  end

  test do
    system "pgloader --version | grep 'pgloader version'"
  end
end
