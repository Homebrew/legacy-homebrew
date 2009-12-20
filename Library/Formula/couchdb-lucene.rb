require 'formula'

class CouchdbLucene <Formula
  version '0.4'
  url 'http://github.com/rnewson/couchdb-lucene/tarball/v' + version
  homepage 'http://github.com/rnewson/couchdb-lucene'
  md5 'b0f3c7c942a0eb80e3f9bff061a0677a'
  
  depends_on 'couchdb'
  depends_on 'maven'
  
  def install
    # Skipping tests because the integration test assumes that couchdb-lucene
    # has been integrated with a local couchdb instance. Not sure if there's a
    # way to only disable the integration test.
    system "mvn", "-DskipTests=true"

    lib_path = lib + "couchdb-lucene"
    index_path = var + "lib/couchdb-lucene"
    log_path = var + "log/couchdb-lucene"
    couchdb_cfg_path = etc + "couchdb/local.d"
    jar_name = "couchdb-lucene-#{version}-jar-with-dependencies.jar"
    
    [lib_path, index_path, log_path, couchdb_cfg_path].each {|p| p.mkpath}
    
    lib_path.install "target/#{jar_name}"
    
    (couchdb_cfg_path + "couchdb-lucene.ini").write <<-EOS
[couchdb]
os_process_timeout=60000 ; increase the timeout from 5 seconds.

[external]
fti=/usr/bin/java -Dcouchdb.lucene.dir=#{index_path} -Dcouchdb.log.dir=#{log_path} -server -jar #{lib_path + jar_name} -search

[update_notification]
indexer=/usr/bin/java -Dcouchdb.lucene.dir=#{index_path} -Dcouchdb.log.dir=#{log_path} -server -jar #{lib_path + jar_name} -index

[httpd_db_handlers]
_fti = {couch_httpd_external, handle_external_req, <<"fti">>}
    EOS
  end
end
