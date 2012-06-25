require 'formula'

class SubRepoStrategy < GitDownloadStrategy
  def initialize url, name, version, specs
    super
    @main_url = @url
    @main_clone = @clone
    @subrepo_url = specs[:subrepo]
    @subrepo_name = File.basename(@subrepo_url, '.git')
    @subrepo_clone = @clone+@subrepo_name
  end

  def fetch
    begin
      super
      @url = @subrepo_url
      @clone = @subrepo_clone
      super
    ensure
      @url = @main_url
      @clone = @main_clone
    end
  end

  def stage
    begin
      super
      @url = @subrepo_url
      @clone = @subrepo_clone
      super
    ensure
      @url = @main_url
      @clone = @main_clone
    end
  end
end

class BdwGc < Formula
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2.tar.gz'
  md5 'd17aecedef3d73e75387fb63558fa4eb'

  head 'git://github.com/ivmai/bdwgc.git',
        :branch => 'master',
        :subrepo => 'git://github.com/ivmai/libatomic_ops.git',
        :using => SubRepoStrategy

  depends_on('autoconf' => :build) if ARGV.build_head?

  def options
    [
      ["--parallel-mark",       "parallelize marking and free list construction"],
      ["--disable-cplusplus",   "disable C++ support"],
      ["--gc-debug",            "include full support for pointer backtracing etc"],
      ["--gc-assertions",       "collector-internal assertion checking"],
      ["--redirect-malloc",     "redirect malloc and friends to GC routines"],
      ["--large-config",        "optimize for large (> 100MB) heap or root set"],
      ["--handle-fork",         "attempt to ensure a usable collector after fork()" \
                                " in multi-threaded programs"]
    ]
  end

  def install
    darwin_release = `uname -r`.to_f.floor
    ENV.append_to_cflags("-D_XOPEN_SOURCE=600 -D_DARWIN_C_SOURCE")
    ENV.remove_from_cflags('-D_XOPEN_SOURCE=600') if 8 >= darwin_release
    ENV.Og unless ARGV.build_stable?

    system "./autogen.sh" if ARGV.build_head?

    args =  "--prefix=#{prefix}",
            '--disable-dependency-tracking',
            '--with-threads=posix',
            '--with-pic',
            '--with-libatomic-ops=check'
    args << '--enable-parallel-mark' if     ARGV.include? '--parallel-mark'
    args << '--enable-cplusplus' unless     ARGV.include? '--disable-cplusplus'
    args << '--enable-gc-debug'if           ARGV.include? '--gc-debug'
    args << '--enable-redirect-malloc' if   ARGV.include? '--redirect-malloc'
    args << '--enable-handle-fork' if       ARGV.include? '--handle-fork'
    args << '--enable-gc-assertions' if     ARGV.include? '--gc-assertions'

    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end
end
