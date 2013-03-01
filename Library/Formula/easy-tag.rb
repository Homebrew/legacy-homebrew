require 'formula'

class EasyTag < Formula
  homepage 'http://easytag.sourceforge.net'
  url 'http://sourceforge.net/projects/easytag/files/easytag%20%28gtk%202%29/2.1/easytag-2.1.7.tar.bz2'
  sha1 '7b56ba18be2f1bec0171e5de4447ba763a264f92'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'libid3tag'
  depends_on 'id3lib' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'speex' => :optional
  depends_on 'flac' => :optional
  depends_on 'mp4v2' => :optional
  depends_on 'wavpack' => :optional

  # Fix compilation against mp4v2 2.0. Can be removed in next version.
  # Based on, with non-apply, non-code changes removed:
  # http://easytag.git.sourceforge.net/git/gitweb.cgi?p=easytag/easytag;a=commitdiff;h=d27ea5803130a25a46be7be98211d4993e671a86
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make install"
  end
end

__END__
diff --git a/src/mp4_header.c b/src/mp4_header.c
index 3b7ec4b..7d699cc 100644
--- a/src/mp4_header.c
+++ b/src/mp4_header.c
@@ -204,7 +204,7 @@ gboolean Mp4_Header_Read_File_Info (gchar *filename, ET_File_Info *ETFileInfo)
     /* Get size of file */
     ETFileInfo->size = Get_File_Size(filename);
 
-    if ((file = MP4Read(filename, 0)) == MP4_INVALID_FILE_HANDLE )
+    if ((file = MP4Read(filename)) == MP4_INVALID_FILE_HANDLE )
     {
         gchar *filename_utf8 = filename_to_display(filename);
         //g_print(_("ERROR while opening file: '%s' (%s)."),filename_utf8,g_strerror(errno));
@@ -218,7 +218,7 @@ gboolean Mp4_Header_Read_File_Info (gchar *filename, ET_File_Info *ETFileInfo)
     {
         gchar *filename_utf8 = filename_to_display(filename);
         Log_Print(LOG_ERROR,_("ERROR while opening file: '%s' (%s)."),filename_utf8,("Contains no audio track"));
-        MP4Close(file);
+        MP4Close(file,0);
         g_free(filename_utf8);
         return FALSE;
     }
@@ -243,7 +243,7 @@ gboolean Mp4_Header_Read_File_Info (gchar *filename, ET_File_Info *ETFileInfo)
     ETFileInfo->mode = MP4GetTrackAudioChannels(file, trackId);
     ETFileInfo->duration = MP4ConvertFromTrackDuration(file, trackId, MP4GetTrackDuration(file, trackId), MP4_SECS_TIME_SCALE);
 
-    MP4Close(file);
+    MP4Close(file,0);
     return TRUE;
 }
 
diff --git a/src/mp4_tag.c b/src/mp4_tag.c
index 1336ee5..ce32d45 100644
--- a/src/mp4_tag.c
+++ b/src/mp4_tag.c
@@ -80,10 +80,7 @@ gboolean Mp4tag_Read_File_Tag (gchar *filename, File_Tag *FileTag)
 {
     FILE   *file;
     MP4FileHandle mp4file = NULL;
-    uint16_t track, track_total;
-    uint16_t disk, disktotal;
-    u_int8_t *coverArt;
-    u_int32_t coverSize;
+		const MP4Tags *mp4tags;
     Picture *prev_pic = NULL;
 #ifdef NEWMP4
     gint pic_num;
@@ -102,7 +99,7 @@ gboolean Mp4tag_Read_File_Tag (gchar *filename, File_Tag *FileTag)
     fclose(file); // We close it cause mp4 opens/closes file itself
 
     /* Get data from tag */
-    mp4file = MP4Read(filename, 0);
+    mp4file = MP4Read(filename);
     if (mp4file == MP4_INVALID_FILE_HANDLE)
     {
         gchar *filename_utf8 = filename_to_display(filename);
@@ -111,34 +108,51 @@ gboolean Mp4tag_Read_File_Tag (gchar *filename, File_Tag *FileTag)
         return FALSE;
     }
 
-    /* TODO Add error detection */
+		mp4tags = MP4TagsAlloc();
+		if (!MP4TagsFetch(mp4tags,mp4file)) {
+			gchar *filename_utf8 = filename_to_display(filename);
+			Log_Print(LOG_ERROR,_("Error reading tags from %s."),filename_utf8);
+			g_free(filename_utf8);
+			return FALSE;
+		}
 
     /*********
      * Title *
      *********/
-    MP4GetMetadataName(mp4file, &FileTag->title);
+		if (mp4tags->name)
+				FileTag->title = strdup(mp4tags->name);
+		else
+				FileTag->title = NULL;
 
     /**********
      * Artist *
      **********/
-    MP4GetMetadataArtist(mp4file, &FileTag->artist);
+		if (mp4tags->artist)
+				FileTag->artist = strdup(mp4tags->artist);
+		else
+				FileTag->artist = NULL;
 
     /*********
      * Album *
      *********/
-    MP4GetMetadataAlbum(mp4file, &FileTag->album);
+		if (mp4tags->album)
+				FileTag->album = strdup(mp4tags->album);
+		else
+				FileTag->album = NULL;
 
     /**********************
      * Disk / Total Disks *
      **********************/
-    if (MP4GetMetadataDisk(mp4file, &disk, &disktotal))
+    if (mp4tags->disk)
     {
-        if (disk != 0 && disktotal != 0)
-            FileTag->disc_number = g_strdup_printf("%d/%d",(gint)disk,(gint)disktotal);
-        else if (disk != 0)
-            FileTag->disc_number = g_strdup_printf("%d",(gint)disk);
-        else if (disktotal != 0)
-            FileTag->disc_number = g_strdup_printf("/%d",(gint)disktotal);
+        if (mp4tags->disk->index != 0 && mp4tags->disk->total != 0)
+            FileTag->disc_number = g_strdup_printf("%d/%d",
+																									 (gint)mp4tags->disk->index,
+																									 (gint)mp4tags->disk->total);
+        else if (mp4tags->disk->index != 0)
+            FileTag->disc_number = g_strdup_printf("%d",(gint)mp4tags->disk->index);
+        else if (mp4tags->disk->total != 0)
+            FileTag->disc_number = g_strdup_printf("/%d",(gint)mp4tags->disk->total);
         //if (disktotal != 0)
         //    FileTag->disk_number_total = g_strdup_printf("%d",(gint)disktotal);
     }
@@ -146,38 +160,53 @@ gboolean Mp4tag_Read_File_Tag (gchar *filename, File_Tag *FileTag)
     /********
      * Year *
      ********/
-    MP4GetMetadataYear(mp4file, &FileTag->year);
+		if (mp4tags->releaseDate)
+				FileTag->year = strdup(mp4tags->releaseDate);
+		else
+				FileTag->year = NULL;
 
     /*************************
      * Track and Total Track *
      *************************/
-    if (MP4GetMetadataTrack(mp4file, &track, &track_total))
+    if (mp4tags->track)
     {
-        if (track != 0)
-            FileTag->track = g_strdup_printf("%.*d",NUMBER_TRACK_FORMATED_SPIN_BUTTON,(gint)track); // Just to have numbers like this : '01', '05', '12', ...
-        if (track_total != 0)
-            FileTag->track_total = g_strdup_printf("%.*d",NUMBER_TRACK_FORMATED_SPIN_BUTTON,(gint)track_total); // Just to have numbers like this : '01', '05', '12', ...
+        if (mp4tags->track->index != 0)
+            FileTag->track = g_strdup_printf("%.*d",NUMBER_TRACK_FORMATED_SPIN_BUTTON,(gint)mp4tags->track->index); // Just to have numbers like this : '01', '05', '12', ...
+        if (mp4tags->track->total != 0)
+            FileTag->track_total = g_strdup_printf("%.*d",NUMBER_TRACK_FORMATED_SPIN_BUTTON,(gint)mp4tags->track->total); // Just to have numbers like this : '01', '05', '12', ...
     }
 
     /*********
      * Genre *
      *********/
-    MP4GetMetadataGenre(mp4file, &FileTag->genre);
+		if (mp4tags->genre)
+				FileTag->genre = strdup(mp4tags->genre);
+		else
+				FileTag->genre = NULL;
 
     /***********
      * Comment *
      ***********/
-    MP4GetMetadataComment(mp4file, &FileTag->comment);
+		if (mp4tags->comments)
+				FileTag->comment = strdup(mp4tags->comments);
+		else
+				FileTag->comment = NULL;
 
     /**********************
      * Composer or Writer *
      **********************/
-    MP4GetMetadataWriter(mp4file, &FileTag->composer);
+		if (mp4tags->composer)
+				FileTag->composer = strdup(mp4tags->composer);
+		else
+				FileTag->composer = NULL;
 
     /*****************
      * Encoding Tool *
      *****************/
-    MP4GetMetadataTool(mp4file, &FileTag->encoded_by);
+		if (mp4tags->encodingTool)
+				FileTag->encoded_by = strdup(mp4tags->encodingTool);
+		else
+				FileTag->encoded_by = NULL;
 
     /* Unimplemented
     Tempo / BPM
@@ -188,9 +217,7 @@ gboolean Mp4tag_Read_File_Tag (gchar *filename, File_Tag *FileTag)
      * Picture *
      ***********/
 #ifdef NEWMP4
-    // There version can handle multiple pictures!
-    // Version 1.6 of libmp4v2 introduces an index argument for MP4GetMetadataCoverart
-    for (pic_num = 0; (MP4GetMetadataCoverArt( mp4file, &coverArt, &coverSize,pic_num )); pic_num++)
+    for (pic_num = 0; pic_num < mp4tags->artworkCount; pic_num++)
 #else
     // There version handle only one picture!
     if ( MP4GetMetadataCoverArt( mp4file, &coverArt, &coverSize ) )
@@ -205,15 +232,16 @@ gboolean Mp4tag_Read_File_Tag (gchar *filename, File_Tag *FileTag)
             prev_pic->next = pic;
         prev_pic = pic;
 
-        pic->size = coverSize;
-        pic->data = coverArt;
+        pic->size = mp4tags->artwork[pic_num].size;
+        pic->data = mp4tags->artwork[pic_num].data;
         pic->type = PICTURE_TYPE_FRONT_COVER;
         pic->description = NULL;
     }
 
 
     /* Free allocated data */
-    MP4Close(mp4file);
+		MP4TagsFree(mp4tags);
+    MP4Close(mp4file,0);
 
     return TRUE;
 }
@@ -234,6 +262,10 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
     gchar    *filename_utf8;
     FILE     *file;
     MP4FileHandle mp4file = NULL;
+		const MP4Tags  *mp4tags;
+		MP4TagDisk disktag;
+		MP4TagTrack tracktag;
+		MP4TagArtwork artwork;
     gint error = 0;
 
     if (!ETFile || !ETFile->FileTag)
@@ -252,23 +284,28 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
     fclose(file);
 
     /* Open file for writing */
-    mp4file = MP4Modify(filename,0,0);
+    mp4file = MP4Modify(filename,0);
     if (mp4file == MP4_INVALID_FILE_HANDLE)
     {
         Log_Print(LOG_ERROR,_("ERROR while opening file: '%s' (%s)."),filename_utf8,_("MP4 format invalid"));
         return FALSE;
     }
 
+		mp4tags = MP4TagsAlloc();
+		if (!MP4TagsFetch(mp4tags,mp4file)) {
+			Log_Print(LOG_ERROR,_("Error reading tags from %s."),filename_utf8);
+			return FALSE;
+		}
+
     /*********
      * Title *
      *********/
     if (FileTag->title && g_utf8_strlen(FileTag->title, -1) > 0)
     {
-        MP4SetMetadataName(mp4file, FileTag->title);
+        MP4TagsSetName(mp4tags, FileTag->title);
     }else
     {
-        //MP4DeleteMetadataName(mp4file); // Not available on mpeg4ip-1.2 (only in 1.3)
-        MP4SetMetadataName(mp4file, "");
+        MP4TagsSetName(mp4tags, NULL);
     }
 
     /**********
@@ -276,11 +313,10 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      **********/
     if (FileTag->artist && g_utf8_strlen(FileTag->artist, -1) > 0)
     {
-        MP4SetMetadataArtist(mp4file, FileTag->artist);
+        MP4TagsSetArtist(mp4tags, FileTag->artist);
     }else
     {
-        //MP4DeleteMetadataArtist(mp4file);
-        MP4SetMetadataArtist(mp4file, "");
+        MP4TagsSetArtist(mp4tags, NULL);
     }
 
     /*********
@@ -288,11 +324,10 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      *********/
     if (FileTag->album && g_utf8_strlen(FileTag->album, -1) > 0)
     {
-        MP4SetMetadataAlbum(mp4file, FileTag->album);
+        MP4TagsSetAlbum(mp4tags, FileTag->album);
     }else
     {
-        //MP4DeleteMetadataAlbum(mp4file);
-        MP4SetMetadataAlbum(mp4file, "");
+        MP4TagsSetAlbum(mp4tags, NULL);
     }
 
     /**********************
@@ -330,11 +365,12 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
         if (FileTag->disc_number_total)
             disktotal = atoi(FileTag->disc_number_total);
         */
-        MP4SetMetadataDisk(mp4file, disk, disktotal);
+				disktag.index = disk;
+				disktag.total = disktotal;
+        MP4TagsSetDisk(mp4tags, &disktag);
     }else
     {
-        //MP4DeleteMetadataDisk(mp4file);
-        MP4SetMetadataDisk(mp4file, 0, 0);
+        MP4TagsSetDisk(mp4tags, NULL);
     }
 
     /********
@@ -342,18 +378,16 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      ********/
     if (FileTag->year && g_utf8_strlen(FileTag->year, -1) > 0)
     {
-        MP4SetMetadataYear(mp4file, FileTag->year);
-    }else
-    {
-        //MP4DeleteMetadataYear(mp4file);
-        MP4SetMetadataYear(mp4file, "");
+        MP4TagsSetReleaseDate(mp4tags, FileTag->year);
+    } else {
+        MP4TagsSetReleaseDate(mp4tags, NULL);
     }
 
     /*************************
      * Track and Total Track *
      *************************/
     if ( (FileTag->track       && g_utf8_strlen(FileTag->track, -1) > 0)
-    ||   (FileTag->track_total && g_utf8_strlen(FileTag->track_total, -1) > 0) )
+	  ||   (FileTag->track_total && g_utf8_strlen(FileTag->track_total, -1) > 0 ) )
     {
         uint16_t track       = 0;
         uint16_t track_total = 0;
@@ -361,11 +395,12 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
             track = atoi(FileTag->track);
         if (FileTag->track_total)
             track_total = atoi(FileTag->track_total);
-        MP4SetMetadataTrack(mp4file, track, track_total);
-    }else
+				tracktag.index = track;
+				tracktag.total = track_total;
+        MP4TagsSetTrack(mp4tags, &tracktag);
+    } else
     {
-        //MP4DeleteMetadataTrack(mp4file);
-        MP4SetMetadataTrack(mp4file, 0, 0);
+        MP4TagsSetTrack(mp4tags, NULL);
     }
 
     /*********
@@ -373,11 +408,11 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      *********/
     if (FileTag->genre && g_utf8_strlen(FileTag->genre, -1) > 0 )
     {
-        MP4SetMetadataGenre(mp4file, FileTag->genre);
+        MP4TagsSetGenre(mp4tags, FileTag->genre);
     }else
     {
-        //MP4DeleteMetadataGenre(mp4file);
-        MP4SetMetadataGenre(mp4file, "");
+        //MP4DeleteMetadataGenre(mp4tags);
+        MP4TagsSetGenre(mp4tags, "");
     }
 
     /***********
@@ -385,11 +420,10 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      ***********/
     if (FileTag->comment && g_utf8_strlen(FileTag->comment, -1) > 0)
     {
-        MP4SetMetadataComment(mp4file, FileTag->comment);
+        MP4TagsSetComments(mp4tags, FileTag->comment);
     }else
     {
-        //MP4DeleteMetadataComment(mp4file);
-        MP4SetMetadataComment(mp4file, "");
+        MP4TagsSetComments(mp4tags, NULL);
     }
 
     /**********************
@@ -397,11 +431,10 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      **********************/
     if (FileTag->composer && g_utf8_strlen(FileTag->composer, -1) > 0)
     {
-        MP4SetMetadataWriter(mp4file, FileTag->composer);
+        MP4TagsSetComposer(mp4tags, FileTag->composer);
     }else
     {
-        //MP4DeleteMetadataWriter(mp4file);
-        MP4SetMetadataWriter(mp4file, "");
+        MP4TagsSetComposer(mp4tags, NULL);
     }
 
     /*****************
@@ -409,11 +442,10 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
      *****************/
     if (FileTag->encoded_by && g_utf8_strlen(FileTag->encoded_by, -1) > 0)
     {
-        MP4SetMetadataTool(mp4file, FileTag->encoded_by);
+        MP4TagsSetEncodingTool(mp4tags, FileTag->encoded_by);
     }else
     {
-        //MP4DeleteMetadataTool(mp4file);
-        MP4SetMetadataTool(mp4file, "");
+        MP4TagsSetEncodingTool(mp4tags, NULL);
     }
 
     /***********
@@ -422,20 +454,31 @@ gboolean Mp4tag_Write_File_Tag (ET_File *ETFile)
     {
         // Can handle only one picture...
         Picture *pic;
-
-        //MP4DeleteMetadataCoverArt(mp4file);
-        MP4SetMetadataCoverArt(mp4file, NULL, 0);
+        MP4TagsSetArtwork(mp4tags,0,NULL);
         for( pic = FileTag->picture; pic; pic = pic->next )
         {
             if( pic->type == PICTURE_TYPE_FRONT_COVER )
             {
-                MP4SetMetadataCoverArt(mp4file, pic->data, pic->size);
+								artwork.data = pic->data;
+								artwork.size = pic->size;
+								switch (pic->type) {
+								case PICTURE_FORMAT_JPEG:
+										artwork.type = MP4_ART_JPEG;
+										break;
+								case PICTURE_FORMAT_PNG:
+										artwork.type = MP4_ART_PNG;
+										break;
+								default:
+										artwork.type = MP4_ART_UNDEFINED;
+								}
+                MP4TagsSetArtwork(mp4tags, 1, &artwork);
             }
         }
     }
 
-
-    MP4Close(mp4file);
+		MP4TagsStore(mp4tags,mp4file);
+		MP4TagsFree(mp4tags);
+    MP4Close(mp4file,0);
 
     if (error) return FALSE;
     else       return TRUE;
-- 
1.7.4.1

