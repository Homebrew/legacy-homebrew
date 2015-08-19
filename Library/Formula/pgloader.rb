class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.2.0.tar.gz"
  sha256 "461dd17d2643891f5add97e22fc8827a95521e3e39a6cca42677a950a7a1dfe0"
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "e7df18f7bd1e102ccbc19c41c7eefdb6e6ad0d2e47f4208031ea430c9a64db9c" => :yosemite
    sha256 "d87322b78f199f9ab0a9ce607a81be831b2f462f94948ee8e2a5bb06a1fdb10d" => :mavericks
    sha256 "616088c4f76e751c5288df14ac66fcaafe8a5849d227e0ff7e116f34ab9ce4b5" => :mountain_lion
  end

  depends_on "sbcl"
  depends_on "freetds"
  depends_on "buildapp" => :build
  depends_on :postgresql => :recommended

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2014-08-26/alexandria-20140826-git.tgz"
    sha256 "9b8420be21384f16e17905be5a90515b0887ae1231e1053ffce2f128ae75fc0b"
  end

  resource "anaphora" do
    url "https://beta.quicklisp.org/archive/anaphora/2011-06-19/anaphora-0.9.4.tgz"
    sha256 "5e7334e0b498cf4c01cf767f6f7e2be6a01895cc6f80d7fcae6d311fee43983f"
  end

  resource "asdf-finalizers" do
    url "https://beta.quicklisp.org/archive/asdf-finalizers/2014-08-26/asdf-finalizers-20140826-git.tgz"
    sha256 "cbb264fd1bea8c0a6c3abf973f55df86408885fa95d5c2017d54b9a019a40752"
  end

  resource "asdf-system-connections" do
    url "https://beta.quicklisp.org/archive/asdf-system-connections/2014-02-11/asdf-system-connections-20140211-git.tgz"
    sha256 "df8bf8fcb0f33535137dfb232183387bef63ae713820c7305d921e5fad9a9669"
  end

  resource "babel" do
    url "https://beta.quicklisp.org/archive/babel/2014-12-17/babel-20141217-git.tgz"
    sha256 "b464ed9fd68c4a6ee9bb77f4f1f414a3b4e4328457a2ed52300eeb5b1ee2d583"
  end

  resource "bordeaux-threads" do
    url "https://beta.quicklisp.org/archive/bordeaux-threads/2013-06-15/bordeaux-threads-0.8.3.tgz"
    sha256 "1e96b51770d9a4a52d1a60b821c2d1807a08b7eb3359a0d1a38349d2353e7630"
  end

  resource "cffi" do
    url "https://beta.quicklisp.org/archive/cffi/2014-11-06/cffi_0.14.0.tgz"
    sha256 "7c3ac3e335f1ae0e758a7f4b7c4831f2b285d3631db070ecb9799b04a07cb194"
  end

  resource "chipz" do
    url "https://beta.quicklisp.org/archive/chipz/2013-01-28/chipz-20130128-git.tgz"
    sha256 "dff908776bd13a55a82a5b87c405651e5927058e2f8275961abf914399daace6"
  end

  resource "chunga" do
    url "https://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz"
    sha256 "efd3a4a1272cc8c04a0875967175abc65e99ff43a5ca0bad12f74f0953746dc7"
  end

  resource "cl+ssl" do
    url "https://beta.quicklisp.org/archive/cl+ssl/2015-03-02/cl+ssl-20150302-git.tgz"
    sha256 "0ac3d820b01343dd4bedfd121cd7e4e7b64ad87a07dbc0b16816949aab546446"
  end

  resource "cl-abnf" do
    url "https://beta.quicklisp.org/archive/cl-abnf/2013-12-11/cl-abnf-20131211-git.tgz"
    sha256 "fc8fe4dabec738d039299512407d4203091acf7701b920b9795e5306d5676dc6"
  end

  resource "cl-base64" do
    url "https://beta.quicklisp.org/archive/cl-base64/2010-10-06/cl-base64-20101006-git.tgz"
    sha256 "dbfe6e22c42e35a5eca9aa0d7a945d5ff7a7ce1d83afe85a9e78162cea619ccc"
  end

  resource "cl-containers" do
    url "https://beta.quicklisp.org/archive/cl-containers/2014-02-11/cl-containers-20140211-git.tgz"
    sha256 "b4eea3b6c8b030f4a62577310e2e748edc234a8a9bf401269f194347e35bfe72"
  end

  resource "cl-csv" do
    url "https://beta.quicklisp.org/archive/cl-csv/2015-03-02/cl-csv-20150302-git.tgz"
    sha256 "78d0acd62bb35cc7125a1bee964b0ae6d51e4a9005abfded7d7a7340a393df27"
  end

  resource "cl-db3" do
    url "https://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz"
    sha256 "b1ffd5c0d0e3eca1a505e20e0c4e888a2ec87f37faa9f1fc62adefc6ceba8d57"
  end

  resource "cl-fad" do
    url "https://beta.quicklisp.org/archive/cl-fad/2014-12-17/cl-fad-0.7.3.tgz"
    sha256 "7fce0593d246463ee42029c3a769ca7f0e8538a4d46c82a26b8fac0b9fe23457"
  end

  resource "cl-interpol" do
    url "https://beta.quicklisp.org/archive/cl-interpol/2010-10-06/cl-interpol-0.2.1.tgz"
    sha256 "7b659ecd994f0a2b4d13f698bf1c7afde9c49f579513d59ed576c6e862d7ca66"
  end

  resource "cl-ixf" do
    url "https://beta.quicklisp.org/archive/cl-ixf/2014-08-26/cl-ixf-20140826-git.tgz"
    sha256 "14c6db515cdb1b34859ef5fde4d3539b27a666938de25a036aee51ec72a4f627"
  end

  resource "cl-log" do
    url "https://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz"
    sha256 "4d7840b9e3bf5a979f780ba937f4e268c73db48e2f91f6c7c541d86e3ac0ab71"
  end

  resource "cl-markdown" do
    url "https://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz"
    sha256 "3c1da678be4f7ee71c245fafa56c1b6f4d3e49e7c6d5cc9b5aafc30abf3e3bc3"
  end

  resource "cl-mssql" do
    url "https://beta.quicklisp.org/archive/cl-mssql/2013-10-03/cl-mssql-20131003-git.tgz"
    sha256 "d34ada2cdabd305fd1d76a02ed60eaf4de02cd2e895060208b41d801c94373fa"
  end

  resource "cl-ppcre" do
    url "https://beta.quicklisp.org/archive/cl-ppcre/2014-12-17/cl-ppcre-2.0.9.tgz"
    sha256 "39c38f4b9cf003b7326c024d777ae71803e5df2468372a8e3e2df66025a64a91"
  end

  resource "cl-sqlite" do
    url "https://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz"
    sha256 "105333bbdccc3c2ab76ce4a35c63e6b27ac8a7a0967971c4addd666df7766135"
  end

  resource "cl-unicode" do
    url "https://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz"
    sha256 "d690480a82bfaa8d5dba29b68bc24f13e4e485f825904e5822879a280bc6a5c9"
  end

  resource "closer-mop" do
    url "https://beta.quicklisp.org/archive/closer-mop/2015-03-02/closer-mop-20150302-git.tgz"
    sha256 "c40dfca4de57ce09c6c17f47afba3512e6132a941036dbfc1a2bad0f63cafcdb"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2014-01-13/command-line-arguments-20140113-git.tgz"
    sha256 "0a3033de15cbd0a7215186bcc450dec031f28ce4a2d4b490aa23b65c23473470"
  end

  resource "drakma" do
    url "https://beta.quicklisp.org/archive/drakma/2014-12-17/drakma-1.3.11.tgz"
    sha256 "ce511f6b7ebc81b8b4bae8729cbee5117e13a5302a66546bfbf99644bc8ff4bb"
  end

  resource "dynamic-classes" do
    url "https://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz"
    sha256 "4a93d3a39dca61c87b29877fa9707b647fc08f117f80f2a741f649e4d04c4b44"
  end

  resource "esrap" do
    url "https://beta.quicklisp.org/archive/esrap/2015-03-02/esrap-20150302-git.tgz"
    sha256 "278848e71d88e5fc62512e816534ed3ca5fa742a73e046de19282dc43809d89a"
  end

  resource "flexi-streams" do
    url "https://beta.quicklisp.org/archive/flexi-streams/2014-12-17/flexi-streams-1.0.14.tgz"
    sha256 "5cb8acf2323de2506e5dcdb0a0d870b1ae788260382c8e65974e4e1e4a9bc460"
  end

  resource "garbage-pools" do
    url "https://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz"
    sha256 "05f014fd95526107af6d99a612b78292fbf3b8a6e9e2efcb04d6ab7e835ab6c5"
  end

  resource "ieee-floats" do
    url "https://beta.quicklisp.org/archive/ieee-floats/2014-07-13/ieee-floats-20140713-git.tgz"
    sha256 "80813b5cc42d9af66c30cdba608411f1e4bbfb1e3e3389dde17244f232e6623f"
  end

  resource "ironclad" do
    url "https://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz"
    sha256 "e7f33e7ad79106de7a7f861013cde2812b83a22f6ab340fb37a6c4fad0efa0d1"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2014-07-13/iterate-20140713-darcs.tgz"
    sha256 "c50264e19b0c5cf52f05dc45889a48c96d449ce24dd15018a228fa6a722405b2"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2015-01-13/local-time-20150113-git.tgz"
    sha256 "d5b6c015de9527e4dc58b7980dd4638c741c15badfd818d9167be141b96b92c6"
  end

  resource "lparallel" do
    url "https://beta.quicklisp.org/archive/lparallel/2015-03-02/lparallel-20150302-git.tgz"
    sha256 "d438a9e2c02c700debbedb3665897220de10c6596406660d48ab562c7200e3a7"
  end

  resource "md5" do
    url "https://beta.quicklisp.org/archive/md5/2013-03-12/md5-20130312-git.tgz"
    sha256 "a05a395259986391a747d95db229dab940bf5e9898b2a024f231a54620d40daf"
  end

  resource "metabang-bind" do
    url "https://beta.quicklisp.org/archive/metabang-bind/2014-11-06/metabang-bind-20141106-git.tgz"
    sha256 "84b0d7384a8f385140a11820e4f57cfd630c8e7ff48b44d357e9af9acd82be86"
  end

  resource "metatilities-base" do
    url "https://beta.quicklisp.org/archive/metatilities-base/2012-09-09/metatilities-base-20120909-git.tgz"
    sha256 "2a0f3f2b3d9724035e03c4bcb9fa587a2a638bd0fd64f20926d83efa09e8d4f8"
  end

  resource "nibbles" do
    url "https://beta.quicklisp.org/archive/nibbles/2015-03-02/nibbles-20150302-git.tgz"
    sha256 "0260de52ed4f3c5186e5b90932e50c213e51f01bbfa7355e10b657400b0d2968"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz"
    sha256 "90ae04cd1a43fe186d07e5f805faa6cc8a00d1134dd9d99b56e31fa2f5811279"
  end

  resource "pgloader" do
    url "https://beta.quicklisp.org/archive/pgloader/2015-03-02/pgloader-3.2.0.tgz"
    sha256 "b6ee64da37b9c781deafbfb5f698bdd2d005bcb03380b7072e0cf1cecc237204"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2014-11-06/postmodern-20141106-git.tgz"
    sha256 "e1c774c703de8c84ae9642b1f0e826d14644963977901b48e6fcade00e9e53a4"
  end

  resource "puri" do
    url "https://beta.quicklisp.org/archive/puri/2010-10-06/puri-20101006-git.tgz"
    sha256 "98237e9103810292a28428c96cc0ace1afcec619db922b5aac800db3123d73d8"
  end

  resource "py-configparser" do
    url "https://beta.quicklisp.org/archive/py-configparser/2013-10-03/py-configparser-20131003-svn.tgz"
    sha256 "9d5365e66f5d788535d53ebf4c733e7d0d47c5b5e5f817c151503325e8c69a81"
  end

  resource "qmynd" do
    url "https://beta.quicklisp.org/archive/qmynd/2015-03-02/qmynd-20150302-git.tgz"
    sha256 "718f58ed381cf14144855a5891f91e995299cfed96d9337e580b305bf2fa3ac4"
  end

  resource "salza2" do
    url "https://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha256 "6aa36dc25fe2dfb411c03ad62edb39fcbf1d4ca8b45ba17a6ad20ebc9f9e10d4"
  end

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2012-07-03/split-sequence-1.1.tgz"
    sha256 "92722b27a57e4d14475f3dc53f8cfe4a304da78ffdc5a181fabb510a78d19281"
  end

  resource "trivial-backtrace" do
    url "https://beta.quicklisp.org/archive/trivial-backtrace/2012-09-09/trivial-backtrace-20120909-git.tgz"
    sha256 "6a36a19ebf88a1ec797cba83d478f52a786ff7c1344e92b2ea36c92adcab9237"
  end

  resource "trivial-features" do
    url "https://beta.quicklisp.org/archive/trivial-features/2015-01-13/trivial-features-20150113-git.tgz"
    sha256 "7601ce226fab155d599c02430db53ed6bb9b529c62bab2471b088ac5cd7ec03a"
  end

  resource "trivial-garbage" do
    url "https://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz"
    sha256 "08c0a03595843576835086dc5973cfb535f75f77de4b90e9c9b97c7eba97c1fb"
  end

  resource "trivial-gray-streams" do
    url "https://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz"
    sha256 "22757737e6b63a21f5e7f44980df8047f8c8294c290eeaaaf01bef1f31b80bda"
  end

  resource "trivial-utf-8" do
    url "https://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha256 "8b17c345da11796663cfd04584445c62f09e789981a83ebefe7970a30b0aafd2"
  end

  resource "uiop" do
    url "https://beta.quicklisp.org/archive/uiop/2014-11-06/uiop-3.1.4.tgz"
    sha256 "82713e93908fcc013b829679324536dc8fcbea772af1b8e40c247abcb4476df8"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2013-07-20/usocket-0.6.1.tgz"
    sha256 "ea64803e15b4197a25e3d0354091dc5590debd7e461a6b8b8f40f0822295d0d2"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz"
    sha256 "0e8657bdf7ad131641f6d878f953ebf74d3cda06b8be99dd8bb8cffbe34308de"
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

  def launch_postgres(socket_dir)
    require "timeout"

    socket_dir = Pathname.new(socket_dir)
    mkdir_p socket_dir

    postgres_command = [
      "postgres",
      "--listen_addresses=",
      "--unix_socket_directories=#{socket_dir}"
    ]

    IO.popen(postgres_command * " ") do |postgres|
      begin
        ohai postgres_command * " "
        # Postgres won't create the socket until it's ready for connections, but
        # if it fails to start, we'll be waiting for the socket forever. So we
        # time out quickly; this is simpler than mucking with child process
        # signals.
        Timeout.timeout(5) { sleep 0.2 while socket_dir.children.empty? }
        yield
      ensure
        Process.kill(:TERM, postgres.pid)
      end
    end
  end

  test do
    # Remove any Postgres environment variables that might prevent us from
    # isolating this disposable copy of Postgres.
    ENV.reject! { |key, _| key.start_with?("PG") }

    ENV["PGDATA"] = testpath/"data"
    ENV["PGHOST"] = testpath/"socket"
    ENV["PGDATABASE"] = "brew"

    (testpath/"test.load").write <<-EOS.undent
      LOAD CSV
        FROM inline (code, country)
        INTO postgresql:///#{ENV["PGDATABASE"]}?tablename=csv
        WITH fields terminated by ','

      BEFORE LOAD DO
        $$ CREATE TABLE csv (code char(2), country text); $$;

      GB,United Kingdom
      US,United States
      CA,Canada
      US,United States
      GB,United Kingdom
      CA,Canada
    EOS

    system "initdb"

    launch_postgres(ENV["PGHOST"]) do
      system "createdb"
      system "pgloader", testpath/"test.load"
      assert_equal "6", shell_output("psql -Atc 'SELECT COUNT(*) FROM csv'").strip
    end
  end
end
