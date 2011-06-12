require 'formula'

class Ioping < Formula
  url 'http://ioping.googlecode.com/files/ioping-0.4.tar.gz'
  head 'http://ioping.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/ioping/'
  md5 '7b3ca5ba313e951e0b970a2ca1cf2512'
  def patches
  	if !ARGV.build_head?
    	DATA
    end
  end
  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
__END__
diff --git a/ioping.c b/ioping_new.c
index 73f3738..91e9461 100644
--- a/ioping.c
+++ b/ioping_new.c
@@ -23,7 +23,6 @@
 #include <stdarg.h>
 #include <getopt.h>
 #include <string.h>
-#include <malloc.h>
 #include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
@@ -37,23 +36,54 @@
 #include <sys/stat.h>
 #include <sys/mount.h>
 #include <sys/ioctl.h>
+#include <sys/disk.h>
+#include <sys/uio.h>
+
+#ifndef HAVE_POSIX_FADVICE
+# define POSIX_FADV_RANDOM	0
+# define POSIX_FADV_DONTNEED	0
+int posix_fadvise(int fd, off_t offset, off_t len, int advice)
+{
+	(void)fd;
+	(void)offset;
+	(void)len;
+	(void)advice;
+
+	errno = ENOSYS;
+	return -1;
+}
+#endif
+
+#ifndef HAVE_POSIX_MEMALLIGN
+/* don't free it */
+int posix_memalign(void **memptr, size_t alignment, size_t size)
+{
+	char *ptr;
+	ptr = malloc(size + alignment);
+	if (!ptr)
+		return -ENOMEM;
+	*memptr = ptr + alignment - (size_t)ptr % alignment;
+	return 0;
+}
+#endif
 
 void usage(void)
 {
 	fprintf(stderr,
-			" Usage: ioping [-LCDhq] [-c count] [-w deadline] [-p period] [-i interval]\n"
+			" Usage: ioping [-LCDRhq] [-c count] [-w deadline] [-p period] [-i interval]\n"
 			"               [-s size] [-S wsize] [-o offset] device|file|directory\n"
 			"\n"
 			"      -c <count>      stop after <count> requests\n"
 			"      -w <deadline>   stop after <deadline>\n"
 			"      -p <period>     print raw statistics for every <period> requests\n"
-			"      -i <interval>   interval between requests (1s)\n"
-			"      -s <size>       request size (4k)\n"
-			"      -S <wsize>      working set size (1m for dirs, full range for others)\n"
+			"      -i <interval>   interval between requests\n"
+			"      -s <size>       request size\n"
+			"      -S <wsize>      working set size\n"
 			"      -o <offset>     in file offset\n"
 			"      -L              use sequential operations rather than random\n"
 			"      -C              use cached-io\n"
 			"      -D              use direct-io\n"
+			"      -R              rate-test, implies: -q -i 0 -w 3\n"
 			"      -h              display this message and exit\n"
 			"      -q              suppress human-readable output\n"
 			"\n"
@@ -168,7 +198,7 @@ char *fstype = "";
 char *device = "";
 
 int fd;
-char *buf;
+void *buf;
 
 int quiet = 0;
 int period = 0;
@@ -200,13 +230,20 @@ void parse_options(int argc, char **argv)
 		exit(1);
 	}
 
-	while ((opt = getopt(argc, argv, "-hLDCqi:w:s:S:c:o:p:")) != -1) {
+	while ((opt = getopt(argc, argv, "hLRDCqi:w:s:S:c:o:p:")) != -1) {
 		switch (opt) {
 			case 'h':
 				usage();
 				exit(0);
 			case 'L':
 				randomize = 0;
+				size = 1<<18;
+				temp_wsize = 1<<26;
+				break;
+			case 'R':
+				interval = 0;
+				deadline = 3000000;
+				quiet = 1;
 				break;
 			case 'D':
 				direct = 1;
@@ -238,63 +275,45 @@ void parse_options(int argc, char **argv)
 			case 'c':
 				count = parse_int(optarg);
 				break;
-			case 1:
-				if (path) {
-					errx(1, "more than one destination: "
-							"\"%s\" and \"%s\"",
-							path, optarg);
-				}
-				path = optarg;
-				break;
 			case '?':
 				usage();
 				exit(1);
 		}
 	}
 
-	if (!path)
+	if (optind > argc-1)
 		errx(1, "no destination specified");
+	if (optind < argc-1)
+		errx(1, "more than one destination specified");
+	path = argv[optind];
 }
 
+
+
 void parse_device(dev_t dev)
 {
-	char *buf = NULL, *ptr;
-	unsigned major, minor;
-	struct stat st;
-	size_t len;
-	FILE *file;
-
-	/* since v2.6.26 */
-	file = fopen("/proc/self/mountinfo", "r");
-	if (!file)
-		goto old;
-	while (getline(&buf, &len, file) > 0) {
-		sscanf(buf, "%*d %*d %u:%u", &major, &minor);
-		if (makedev(major, minor) != dev)
-			continue;
-		ptr = strstr(buf, " - ") + 3;
-		fstype = strdup(strsep(&ptr, " "));
-		device = strdup(strsep(&ptr, " "));
-		goto out;
-	}
-old:
-	/* for older versions */
-	file = fopen("/proc/mounts", "r");
-	if (!file)
+	struct statfs fs;
+	(void)dev;
+
+	if (statfs(path, &fs))
 		return;
-	while (getline(&buf, &len, file) > 0) {
-		ptr = buf;
-		strsep(&ptr, " ");
-		if (*buf != '/' || stat(buf, &st) || st.st_rdev != dev)
-			continue;
-		strsep(&ptr, " ");
-		fstype = strdup(strsep(&ptr, " "));
-		device = strdup(buf);
-		goto out;
-	}
-out:
-	free(buf);
-	fclose(file);
+
+	fstype = strdup(fs.f_fstypename);
+	device = strdup(fs.f_mntfromname);
+}
+
+off_t get_device_size(int fd)
+{
+	unsigned long long blksize = 0;
+	int ret;
+
+	ret = ioctl(fd, DKIOCGETBLOCKCOUNT, &blksize);
+	blksize <<= 9;
+
+	if (ret)
+		err(2, "block get size ioctl failed");
+
+	return blksize;
 }
 
 void sig_exit(int signo)
@@ -325,6 +344,11 @@ int main (int argc, char **argv)
 
 	parse_options(argc, argv);
 
+#ifndef HAVE_POSIX_FADVICE
+	direct |= !cached;
+	cached = 1;
+#endif
+
 	if (wsize)
 		temp_wsize = wsize;
 	else if (size > temp_wsize)
@@ -334,8 +358,10 @@ int main (int argc, char **argv)
 		errx(1, "request size must be greather than zero");
 
 	flags = O_RDONLY;
+#ifdef O_DIRECT
 	if (direct)
 		flags |= O_DIRECT;
+#endif
 
 	if (stat(path, &st))
 		err(2, "stat \"%s\" failed", path);
@@ -346,19 +372,17 @@ int main (int argc, char **argv)
 		if (!quiet)
 			parse_device(st.st_dev);
 	} else if (S_ISBLK(st.st_mode)) {
-		unsigned long long blksize;
-
 		fd = open(path, flags);
 		if (fd < 0)
 			err(2, "failed to open \"%s\"", path);
 
-		ret = ioctl(fd, BLKGETSIZE64, &blksize);
-		if (ret)
-			err(2, "block get size ioctl failed");
-		st.st_size = blksize;
+		st.st_size = get_device_size(fd);
 
-		fstype = "block";
-		device = "device";
+		fstype = "block device";
+		device = malloc(32);
+		if (!device)
+			err(2, "no mem");
+		snprintf(device, 32, "%.1f Gb", (double)st.st_size/(1ll<<30));
 	} else {
 		errx(2, "unsupported destination: \"%s\"", path);
 	}
@@ -372,8 +396,8 @@ int main (int argc, char **argv)
 	if (size > wsize)
 		errx(2, "request size is too big for this target");
 
-	buf = memalign(sysconf(_SC_PAGE_SIZE), size);
-	if (!buf)
+	ret = posix_memalign(&buf, sysconf(_SC_PAGE_SIZE), size);
+	if (ret)
 		errx(2, "buffer allocation failed");
 	memset(buf, '*', size);
 
@@ -409,6 +433,11 @@ int main (int argc, char **argv)
 			err(2, "failed to open \"%s\"", path);
 	}
 
+#ifdef F_NOCACHE
+	if (fcntl(fd, F_NOCACHE, direct))
+		err(2, "fcntl nocache failed");
+#endif
+
 	if (!cached) {
 		ret = posix_fadvise(fd, offset, wsize, POSIX_FADV_RANDOM);
 		if (ret)
@@ -511,14 +540,17 @@ int main (int argc, char **argv)
 	time_avg = time_sum / request;
 	time_mdev = sqrt(time_sum2 / request - time_avg * time_avg);
 
-	if (!quiet) {
+	if (!quiet || !period) {
 		printf("\n--- %s ioping statistics ---\n", path);
-		printf("%d requests completed in %.1f ms\n",
-				request, time_total/1000.);
+		printf("%d requests completed in %.1f ms, %.0f iops %.1f mb/s\n",
+				request, time_total/1000.,
+				request * 1000000. / time_sum,
+				(double)request * size / time_sum /
+				(1<<20) * 1000000);
 		printf("min/avg/max/mdev = %.1f/%.1f/%.1f/%.1f ms\n",
 				time_min/1000., time_avg/1000.,
 				time_max/1000., time_mdev/1000.);
 	}
 
 	return 0;
-}
+}
\ No newline at end of file
