When updating certain formulae's version, also do:
=============

OpenSSL:
* tor: Revision; Throws runtime warnings about mismatched compile => run OpenSSL versions.
* freeradius-Server: Revision; Throws runtime warnings about mismatched compile => run OpenSSL versions.
* Python; Can throw tantrums about OpenSSL version/revision bump. Check.
* Python3; Can throw tantrums about OpenSSL version/revision bump. Check.
* Ruby; Can throw tantrums about OpenSSL version/revision bump. Check.

Libgpg-error:
* libgcrypt: Revision; Otherwise breaks everything.

Python:
* sip: Revision; Stale Python include dir linked; The config file permanently stores the include path.

Node:
* Update npm version shipped every 4 minor or 1 major updates, and revision formula.

Boost:
* Check postgis to see if revision required
* Check sfcgal to see if revision required
* Check encfs to see if revision required

Libunistring:
* guile; bump revision.

Gcc:
* For every .x. update, bump ghc revision. (This might be fixed by Misty's gcc version fix PR)

Icu4c:
* beecrypt; Revision
* couchdb; Revision
* dwdiff; Revision
* freeling; Revision
* gptfdisk; Revision
* harfbuzz; Revision
* mapnik; Revision
* parrot; Revision
* rakudo-star; Revision
* szl; Revision

Ffmpeg:
* For every update, check upstream git announcement for API/ABI status. If not compatible, revision...
* caudec
* echoprint-codegen  
* gifify
* libquicktime
* mkvdts2ac3
* moc
* phash
* chromaprint
* ffmpeg2theora
* gpac
* mediatomb
* mkvtomp4
* mpd
* pianobar
* cmus
* ffmpegthumbnailer
* libgroove
* minidlna
* mlt
* open-scene-graph

Nettle:
For every .x. version bump, check dependents. They often need recompiling, but check first:
* gnutls
* lsh
* pike
* rdfind
* rdup
* s3fs
* stoken