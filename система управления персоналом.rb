GLib has g_str_equal() and g_str_has_prefix(), which are much easier to use than
strcmp(...) == 0 or strncmp(e1, e2, len) == 0. Use them. The following semantic
patch found and replaced all occurrences - except in ndmp-src and *.swig:

----
@@
expression e1, e2, e3;
@@

(
- strncmp(e1, e2, e3) == 0
+ g_str_has_prefix(e1, e2)
|
- strcmp(e1, e2) == 0
+ g_str_equal(e1, e2)
|
- strncmp(e1, e2, e3) != 0
+ !g_str_has_prefix(e1, e2)
|
- strcmp(e1, e2) != 0
+ !g_str_equal(e1, e2)
)

#IFNDEF AMANDA_H
#Определите AMANDA_H

#Ифдеф HAVE_CONFIG_H
/* используйте здесь относительный путь, чтобы избежать конфликта с config.h Perl. */
#включить ".. /config/config.h"
#Эндиф

# Включите <glib.h>
#включить <glib/gprintf.h>

#Включите "amflock.h"

#Определите GCC_VERSION (__GNUC__ * 10000 \
                     + __GNUC_MINOR__ * 100 \
                     + __GNUC_PATCHLEVEL__)

/*
 * Обработка вараргов/эллипсисов: некоторые сломанные системы НЕ объявляют STDC_HEADERS,
 * что означает, что va_start ведет себя по-другому :/ Итак, используйте наши собственные
 */
#Ифдеф STDC_HEADERS

#Включите <stdarg.h>
#Определите arglist_start(arg,hook_name) va_start(arg,hook_name)

#иначе /* ! STDC_HEADERS */

# Включите <varargs.h>
#Определите arglist_start(arg,hook_name) va_start(arg)

#endif /* STDC_HEADERS */ 

#Определите arglist_val(arg;type) va_arg(arg;type)
#Определение arglist_end(arg) va_end(arg)

/*
 * Принудительно использовать источник большого файла, даже если конфигурация угадывает неправильно.
 */
#IFNDEF _FILE_OFFSET_BITS
#Определите _FILE_OFFSET_BITS 64
#Эндиф

#Ифдеф HAVE_SYS_TYPES_H
#  включить <sys/types.h>
#Эндиф

/* gnulib creates this header locally if the system doesn't provide it,
 * so it uses a local ("") include */
#include "stdint.h"

/*
 * I would prefer that each Amanda module include only those system headers
 * that are locally needed, but on most Unixes the system header files are not
 * protected against multiple inclusion, so this can lead to problems.
 *
 * Also, some systems put key files in different places, so by including 
 * everything here the rest of the system is isolated from such things.
 */

/* from the autoconf documentation */
#ifdef HAVE_DIRENT_H
#  include <dirent.h>
#  define NAMLEN(dirent) strlen((dirent)->d_name)
#else
#  define dirent direct
#  define NAMLEN(dirent) (dirent)->d_namlen
#  if HAVE_SYS_NDIR_H
#    include <sys/ndir.h>
#  endif
#  if HAVE_SYS_DIR_H
#    include <sys/dir.h>
#  endif
#  if HAVE_NDIR_H
#    include <ndir.h>
#  endif
#endif

#ifdef ENABLE_NLS
#  include <libintl.h>
#  include <locale.h>
#  define  plural(String1, String2, Count)				\
		(((Count) == 1) ? (String1) : (String2))
#else
#  define plural(String1, String2, Count)				\
		(((Count) == 1) ? (String1) : (String2))
#  define setlocale(Which, Locale)
#  define textdomain(Domain)
#  define bindtextdomain(Package, Directory)
#  define gettext(String)			String
#  define dgettext(Domain, String)		String
#  define dcgettext(Domain, String, Catagory)	String
#  define ngettext(String1, String2, Count)				\
		plural((String1), (String2), (Count))
#  define dngettext(Domain, String1, String2, Count)			\
		plural((String1), (String2), (Count))
#  define dcngettext(Domain, String1, String2, Count, Catagory)		\
		plural((String1), (String2), (Count))
#endif
#define T_(String)			String
#ifndef SWIG /* TODO: make this go away */
#define _(String)			dgettext("amanda", (String))
#endif

#ifdef HAVE_FCNTL_H
#  include <fcntl.h>
#endif

#ifdef HAVE_GRP_H
#  include <grp.h>
#endif

#if defined(USE_DB_H)
#  include <db.h>
#else
#if defined(USE_DBM_H)
#  include <dbm.h>
#else
#if defined(USE_GDBM_H)
#  include <gdbm.h>
#else
#if defined(USE_NDBM_H)
#  include <ndbm.h>
#endif
#endif
#endif
#endif

#ifdef TIME_WITH_SYS_TIME
#  include <sys/time.h>
#  include <time.h>
#else
#  ifdef HAVE_SYS_TIME_H
#    include <sys/time.h>
#  else
#    include <time.h>
#  endif
#endif

#ifdef HAVE_LIBC_H
#  include <libc.h>
#endif

#ifdef HAVE_STDLIB_H
#  include <stdlib.h>
#endif

#ifdef HAVE_LIBGEN_H
#  include <libgen.h>
#endif

#ifdef HAVE_STRING_H
#  include <string.h>
#endif

#ifdef HAVE_STRINGS_H
#  include <strings.h>
#endif

#ifdef HAVE_SYSLOG_H
#  include <syslog.h>
#endif

#ifdef HAVE_MATH_H
#  include <math.h>
#endif

#ifdef HAVE_SYS_FILE_H
#  include <sys/file.h>
#endif

#ifdef HAVE_SYS_IOCTL_H
#  include <sys/ioctl.h>
#endif

#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif

#ifdef HAVE_SYS_PARAM_H
#  include <sys/param.h>
#endif

#if defined(HAVE_SYS_IPC_H) && defined(HAVE_SYS_SHM_H)
#  include <sys/ipc.h>
#  include <sys/shm.h>
#else
#  ifdef HAVE_SYS_MMAN_H
#    include <sys/mman.h>
#  endif
#endif

#ifdef HAVE_SYS_SELECT_H
#  include <sys/select.h>
#endif

#ifdef HAVE_SYS_STAT_H
#  include <sys/stat.h>
#endif

#ifdef HAVE_SYS_UIO_H
#  include <sys/uio.h>
#else
struct iovec {
    void *iov_base;
    int iov_len;
};
#endif

#ifdef HAVE_WAIT_H
#  include <wait.h>
#endif

#ifdef HAVE_SYS_WAIT_H
#  include <sys/wait.h>
#endif

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif

#ifdef WAIT_USES_INT
  typedef int amwait_t;
# ifndef WEXITSTATUS
#  define WEXITSTATUS(stat_val) (*(unsigned*)&(stat_val) >> 8)
# endif
# ifndef WTERMSIG
#  define WTERMSIG(stat_val) (*(unsigned*)&(stat_val) & 0x7F)
# endif
# ifndef WIFEXITED
#  define WIFEXITED(stat_val) ((*(unsigned*)&(stat_val) & 255) == 0)
# endif
#else
# ifdef WAIT_USES_UNION
   typedef union wait amwait_t;
#  ifndef WEXITSTATUS
#  define WEXITSTATUS(stat_val) (((amwait_t*)&(stat_val))->w_retcode)
#  endif
#  ifndef WTERMSIG
#   define WTERMSIG(stat_val) (((amwait_t*)&(stat_val))->w_termsig)
#  endif
#  ifndef WIFEXITED
#   define WIFEXITED(stat_val) (WTERMSIG(stat_val) == 0)
#  endif
# else
   typedef int amwait_t;
#  ifndef WEXITSTATUS
#   define WEXITSTATUS(stat_val) (*(unsigned*)&(stat_val) >> 8)
#  endif
#  ifndef WTERMSIG
#   define WTERMSIG(stat_val) (*(unsigned*)&(stat_val) & 0x7F)
#  endif
#  ifndef WIFEXITED
#   define WIFEXITED(stat_val) ((*(unsigned*)&(stat_val) & 255) == 0)
#  endif
# endif
#endif

#ifndef WIFSIGNALED
# define WIFSIGNALED(stat_val)	(WTERMSIG(stat_val) != 0)
#endif

#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif

#if HAVE_EUIDACCESS
#   define EUIDACCESS euidaccess
#elif HAVE_EACCESS
#   define EUIDACCESS eaccess
#else
#   define EUIDACCESS access
#endif


#ifdef HAVE_NETINET_IN_H
#  include <netinet/in.h>
#endif

# Включите <ctype.h>
# включить <errno.h>
#Включите <pwd.h>
# включить <signal.h>
# Включите <setjmp.h>
# Включите <stdio.h>
#включить <sys/resource.h>
#включить <sys/socket.h>

#Ифдеф WORKING_IPV6
#определить INET6
#Эндиф

#IFNDEF INET_ADDRSTRLEN
#Определите INET_ADDRSTRLEN 16
#Эндиф

#if !defined(HAVE_SIGACTION) && defined(HAVE_SIGVEC)
/* quick'n'dirty hack для NextStep31 */
#  Определите sa_flags sv_flags
#  Определите sa_handler sv_handler
#  Определите sa_mask sv_mask
#  Определение sigaction sigvec 
#  Определите sigemptyset(mask) /* нет возможности очистить ожидающие сигналы */ 
#Эндиф

/*
 * Большинство Unixen объявляют errno в <errno.h>, некоторые этого не делают. Некоторые многопоточные
 * Системы имеют errno в качестве макроса для каждого потока. Поэтому мы должны быть осторожны.
 */
#ifndef errno
extern int errno;
#Эндиф

/*
 * Некоторые старые системы BSD не имеют этих макросов FD_, поэтому, если нет, предоставьте их.
 */
#if !defined(FD_SET) || defined(LINT) || определено(__lint)
#  ФДООН FD_SETSIZE
#  Определите FD_SETSIZE (int)(sizeof(fd_set) * CHAR_BIT)

#  ФДООН FD_SET
#  Определите FD_SET(n, p) (((fd_set *)(p))->fds_bits[(n)/WORD_BIT] |= (int)((1 << ((n) % WORD_BIT))))

#  ФДООН FD_CLR
#  определить FD_CLR(n, p) (((fd_set *)(p))->fds_bits[(n)/WORD_BIT] &= (int)(~(1 << ((n) % WORD_BIT))))

#  ФДООН FD_ISSET
#  Определите FD_ISSET(n, p) (((fd_set *)(p))->fds_bits[(n)/WORD_BIT] & (1 << ((n) % WORD_BIT)))

#  ФДООН FD_ZERO
#  Определим FD_ZERO(p) memset((p), 0, sizeof(*(p)))
#Эндиф

#IFNDEF FD_COPY
#  Определите FD_COPY(p, q) memcpy((q), (p), sizeof(*(p)))
#Эндиф


/*
 * Определите MAX_HOSTNAME_LENGTH как размер массивов для хранения имен хостов.
 */
#ФДООН MAX_HOSTNAME_LENGTH
#Определите MAX_HOSTNAME_LENGTH 1025

/*
 * Если пустота нарушена, замените ее обугливанием.
 */
#Ифдеф BROKEN_VOID
#  Определение символа пустоты 
#Эндиф

#define stringize(x) #x
#define stringconcat(x, y) x ## y

/* Аманда #days расчет, с округлением */

# Определите SECS_PER_DAY (24*60*60)
#Определите days_diff(a, b) (int)(((b) - (a) + SECS_PER_DAY/2) / SECS_PER_DAY)

/* Глобальные константы. */
#IFNDEF AMANDA_SERVICE_NAME
# Определите AMANDA_SERVICE_NAME «Аманда»
#Эндиф

#Определите am_round(v,u) ((((v) + (u) - 1) / (u)) * (u))
#Определите am_floor(v,u) (((v) / (u)) * (u))

/* Размер блока удерживающего диска. Даже не думайте об этом! :-) */
#Определите DISK_BLOCK_KB 32
#Определите DISK_BLOCK_BYTES (DISK_BLOCK_KB * 1024)

/* Максимальная длина этикетки ленты, плюс одна для нулевого терминатора. */
#Определите MAX_TAPE_LABEL_LEN (10240)
#Определите MAX_TAPE_LABEL_BUF (MAX_TAPE_LABEL_LEN+1)
#Определите MAX_TAPE_LABEL_FMT "%10240s"

#включить "sockaddr-util.h"
#Включите "debug.h"
#включить "file.h"

/*@only@*/ /*@null@*/ char *debug_agets(const char *file, int line, FILE *f);
/*@only@*/ /*@null@*/ char *debug_areads(const char *file, int line, int fd);
#Определение agets(f) debug_agets(__FILE__,__LINE__,(f))
#Определите areads(f) debug_areads(__FILE__,__LINE__,(f))

/* возвращают "безопасную" версию текущей среды; Передайте это в execle */
#define safe_env() safe_env_full(NULL)

/* как safe_env, но при необходимости добавьте дополнительные переменные окружения */
char **	safe_env_full(char **add);
void free_env(char **env);

time_t unctime(char *timestr);

/*
 * amfree(ptr) -- если выделено, освободите место и установите ptr в NULL.
 *
 * В общем, это должно быть вызвано вместо просто free(), если только
 * Уже следующая исходная строка устанавливает указатель на новое значение.
 */

#Определите amfree(ptr) do {						\
    if((ptr) != NULL) {							\
	int e__errno = errno;						\
	свободный (птр); \
	(ptr) = NULL;							\
	errno = e__errno;						\
	(ничтожный) (ПТР); /* Исправлено значение, которое никогда не использовалось, предупреждение в конце процедур */ \
    }									\
} в то время как (0)

#Определите Strappend(S1,S2) do {						\
    char *t_t_t = (s1) ? g_strconcat(s1, s2, NULL) : g_strdup((s2)); \
    amfree((s1));							\
    (s1) = t_t_t;							\
} в то время(0)

/*
 * мин/макс. Не делайте что-то вроде
 *
 * x = мин(y++, z);
 *
 * т.к. приращение будет дублироваться.
 */
#undef min
#UNDEF Макс
#Определите min(a, b) ((a) < (b) ? (а) : (b))
#Определите max(a, b) ((a) > (b) ? (а) : (b))

/*
 * Утилита манипулирования битовыми масками макросов.
 */
#определить SET(t, f) ((t) |= (f))
#define CLR(t, f) ((t) &= ~((unsigned)(f)))
#определить ISSET(t, f) ((t) и (f))

/*
 * Макросы служебной строки. Все предполагают, что переменная содержит стик
 * и строковый указатель указывает на следующий символ
 * быть обработанным. Типичная установка:
 *
 * s = буфер;
 *  ch = *s++;
 * skip_whitespace(ы, гл);
 *  ...
 *
 * Если вы продвигаете указатель «вручную», чтобы что-то пропустить, сделайте
 * Это так:
 *
 *  s += some_amount;
 *  ch = s[-1];
 *
 * Обратите внимание, что символ ch находится в конце только что пропущенного поля.
 * Часто бывает полезно завершить строку, сделать копию, а затем восстановить
 * Ввод такой:
 *
 * skip_whitespace(ы, гл);
 * FP = С-1; ## Сохраните старт
 * skip_nonwhitespace(с, гл); ## Найди конец
 * p[-1] = '\0'; ## Временное прекращение
 * поле = g_strdup(FP); ## сделать копию
 * p[-1] = ch; ## восстановить входные данные
 *
 * Макросы сканирования:
 *
 *  skip_whitespace (ptr, var)
 * -- пропускает пробелы, но останавливается на новой строке
 *  skip_non_whitespace (ptr, var)
 * -- пропустить без пробелов
 *  skip_non_whitespace_cs (ptr, var)
 * -- пропустить без пробелов, остановиться на комментарии
 *  skip_integer (ptr, var)
 * -- пропустить целочисленное поле
 *  skip_line (ptr, var)
 * -- пропустить следующую новую строку
 *  strncmp_const (str, const_str)
 * -- сравните str с const_str, строковой константой
 *  strncmp_const_skip (str, const_var, ptr, var)
 *  strncmp_const_skip_no_var(str, const_var, ptr)
 * -- как strncmp_const, но пропустите строку, если совпадение
 *основывать; Этот макрос только проверяет равенство, отбрасывая
 * Информация о заказе.
 *
 *где:
 *
 * ptr -- строковый указатель
 * var -- текущий символ
 *
 * Эти макросы копируют поле, не содержащее пробелов, в новый буфер и должны
 * используется только в том случае, если динамическое распределение невозможно (буферы фиксированного размера
 * напрашиваются на неприятности):
 *
 *  copy_string (ptr, var, field, len, fldptr)
 * -- скопировать поле без пробелов
 *  copy_string_cs (ptr, var, field, len, fldptr)
 * -- скопируйте поле, не содержащее пробелов, остановитесь на комментарии
 *
 *где:
 *
 * ptr -- строковый указатель
 * var -- текущий символ
 * field -- область для копирования
 * len -- длина области (требуется место для нулевого байта)
 * fldptr -- рабочий указатель, используемый в перемещении
 * если NULL при выходе, поле было слишком маленьким для ввода
 */

#Определите STR_SIZE 4096 /* общий размер строкового буфера */ 
#Определите NUM_STR_SIZE 128 /* общий размер числового буфера */ 

#Определите skip_whitespace(ptr,c) do {					\
    while((c) != '\n' && g_ascii_isspace((int)c)) (c) = *(ptr)++; \
} в то время(0)

#Определите skip_non_whitespace(ptr,c) do {					\
    while((c) != '\0' && ! g_ascii_isspace((int)c)) (c) = *(ptr)++; \
} в то время(0)

#Определите skip_non_whitespace_cs(ptr,c) do {				\
    while((c) != '\0' && (c) != '#' && ! g_ascii_isspace((int)c)) (c) = *(ptr)++;\
} в то время(0)

#Определите skip_non_integer(ptr,c) do {					\
    while((c) != '\0' && ! isdigit(c)) (c) = *(ptr)++; \
} в то время(0)

#Определите skip_integer(ptr,c) do {					\
    if((c) == '+' || (c) == '-') (c) = *(ptr)++; \
    while(isdigit(c)) (c) = *(ptr)++;					\
} в то время(0)

#Определите skip_quoted_string(ptr, c) do {					\
    int	iq = 0;								\
    while (((c) != '\0') && !( (iq == 0) && g_ascii_isspace((int)c))) { \
	если ((с) == '"') {						\
	    iq = !iq;							\
	} иначе, если ((c) == '\\') {					\
	    if (*ptr) /* не последний символ */			\
 (ПТР)++; \
	}								\
 c) = *(ptr)++; \
    }									\
} в то время как (0)

#Определите skip_quoted_line(ptr, c) do {					\
    int	iq = 0;								\
    while((c) && !( (iq == 0) && ((c) == '\n'))) {			\
	если ((с) == '"')							\
	    iq = !iq;							\
 c) = *(ptr)++; \
    }									\
    if(c)								\
 c) = *(ptr)++; \
} в то время(0)

#Определите skip_line(ptr,c) do {						\
    while((c) && (c) != '\n')						\
 c) = *(ptr)++; \
    if(c)								\
 c) = *(ptr)++; \
} в то время(0)

#Определите copy_string(PTR,C,F,L,FP) DO {					\
    (fp) = (f);								\
    while((c) != '\0' && ! g_ascii_isspace((int)c)) { \
	if((fp) >= (f) + (l) - 1) {					\
 *(fp) = '\0';						\
	    (fp) = NULL;						\
	    (ничтожный) (ФП); /* Исправлено значение, которое никогда не использовалось, предупреждение в конце процедур */ \
	    ломать;							\
	}								\
	*(fp)++ = (c);							\
 c) = *(ptr)++; \
    }									\
    if(fp)								\
 *fp = '\0';							\
} в то время(0)

#Определите copy_string_cs(PTR,C,F,L,FP) DO {				\
    (fp) = (f);								\
    while((c) != '\0' && (c) != '#' && ! g_ascii_isspace((int)c)) { \
	if((fp) >= (f) + (l) - 1) {					\
 *(fp) = '\0';						\
	    (fp) = NULL;						\
	    ломать;							\
	}								\
	*(fp)++ = (c);							\
 c) = *(ptr)++; \
    }									\
    if(fp) *fp = '\0';							\
} в то время(0)

#Определите is_dot_or_dotdot)						\
 ((s)[0] == '.'							\
 && ((s)[1] == '\0'							\
 || ((s)[1] == '.' && (s)[2] == '\0')))

#Определите strncmp_const(str, cnst)					\
	strncmp((str), (cnst), sizeof((cnst))-1)

/* (нужно свернуть это в выражение, чтобы его можно было использовать в if()) */
#Определите strncmp_const_skip(STR, CNST, PTR, VAR)				\
	((g_str_has_prefix((str), (cnst)))?		\
		 ((ptr)+=sizeof((cnst))-1, (var)=(ptr)[-1], 0)		\
		:1)

/* (нужно свернуть это в выражение, чтобы его можно было использовать в if()) */
#Определите strncmp_const_skip_no_var(STR, CNST, PTR)				\
	((g_str_has_prefix((str), (cnst)))?		\
		 ((ptr)+=sizeof((cnst))-1, 0)		\
		:1)

/* из старого bsd-security.c */
extern int check_security(sockaddr_union *, char *, unsigned long, char **,  char  *);

/*
 * Обработка функций, которые не всегда объявлены во всех системах. Этот
 * останавливает gcc -Wall и lint от жалоб.
 */

/* AIX #defines принять и предоставить прототип альтернативного имени */
#if !defined(HAVE_ACCEPT_DECL) && !defined(accept)
extern int accept(int s, struct sockaddr *addr, socklen_t_equiv *addrlen);
#Эндиф

#IFNDEF HAVE_ATOF_DECL
extern double atof(const char *ptr);
#Эндиф

#IFNDEF HAVE_BCOPY
# Определите bcopy(from,to,n) ((void)memmove((to), (from), (n)))
#еще
# IFNDEF HAVE_BCOPY_DECL
внешняя пустота bcopy(const void *s1, void *  s2, size_t n);
# Эндиф
#Эндиф

#IFNDEF HAVE_BIND_DECL
extern  int bind(int s, const struct sockaddr *name, socklen_t_equiv namelen);
#Эндиф

#IFNDEF HAVE_BZERO
#Определим bzero(s,n) ((void)memset((s),0,(n)))
#еще
# IFNDEF HAVE_BZERO_DECL
extern  void bzero(void *s, size_t n);
# Эндиф
#Эндиф

#IFNDEF HAVE_CLOSELOG_DECL
extern  void closelog(void);
#Эндиф

#IFNDEF HAVE_CONNECT_DECL
extern int connect(int s, struct sockaddr *name, socklen_t_equiv namelen);
#Эндиф

#IFNDEF HAVE_FCLOSE_DECL
extern int fclose(FILE *stream);
#Эндиф

#IFNDEF HAVE_FFLUSH_DECL
extern int fflush(FILE *stream);
#Эндиф

#IFNDEF HAVE_FPRINTF_DECL
extern int fprintf(FILE *stream, const char *format, ...);
#Эндиф

#IFNDEF HAVE_FPUTC_DECL
extern  int fputc(int c, FILE *stream);
#Эндиф

#IFNDEF HAVE_FPUTS_DECL
extern int fputs(const char *s, FILE *stream);
#Эндиф

#IFNDEF HAVE_FREAD_DECL
extern size_t fread(void *ptr, size_t size, size_t nitems,  FILE *stream);
#Эндиф

#IFNDEF HAVE_FSEEK_DECL
extern int fseek(FILE *stream, long offset, int ptrname);
#Эндиф

#IFNDEF HAVE_FWRITE_DECL
extern size_t fwrite(const void *ptr, размер size_t, size_t nitems,
 FILE *поток);
#Эндиф

#IFNDEF HAVE_GETHOSTNAME_DECL
extern int gethostname(char *name, int namelen);
#Эндиф

#IFNDEF HAVE_GETOPT_DECL
extern char *optarg;
extern  int getopt(int argc, char * const *argv, const char *optstring);  
#Эндиф

/* AIX #defines getpeername и предоставляет прототип альтернативного имени */
#if !defined(HAVE_GETPEERNAME_DECL) && !defined(getpeername)
extern  int getpeername(int s, struct sockaddr *name, socklen_t_equiv *namelen);
#Эндиф

/* AIX #defines getsockname и предоставляет прототип для альтернативного имени */
#if !defined(HAVE_GETSOCKNAME_DECL) && !defined(getsockname)
extern  int getsockname(int s, struct sockaddr *name, socklen_t_equiv *namelen);
#Эндиф

#IFNDEF HAVE_GETSOCKOPT_DECL
extern  int getsockopt(int s, int level, int optname,  char *optval,
			 socklen_t_equiv *optlen);
#Эндиф

#IFNDEF HAVE_INITGROUPS
# Определение initgroups(имя;basegid) 0
#еще
# IFNDEF HAVE_INITGROUPS_DECL
extern int initgroups(const char *name, gid_t basegid);
# Эндиф
#Эндиф

#IFNDEF HAVE_IOCTL_DECL
extern  int ioctl(int fildes, int request, ...);
#Эндиф

#IFNDEF - это нормально
#IFNDEF HAVE_ISNORMAL
#Определите isnormal(f) (((f) < 0.0) || f) > 0,0))
#Эндиф
#Эндиф

#IFNDEF HAVE_LISTEN_DECL
extern  int listen(int s, int backlog);
#Эндиф

#IFNDEF HAVE_LSTAT_DECL
extern int lstat(const char *path, struct stat *buf);
#Эндиф

#IFNDEF HAVE_MALLOC_DECL
внешняя пустота *malloc (size_t размер);
#Эндиф

#IFNDEF HAVE_MEMMOVE_DECL
#Ифдеф HAVE_MEMMOVE
extern  void *memmove(void *to, const void *from, size_t n);
#еще
extern  char *memmove(char *to, /*const*/ char *  from, size_t n);
#Эндиф
#Эндиф

#IFNDEF HAVE_MEMSET_DECL
extern  void *memset(void *s, int c, size_t n);
#Эндиф

#IFNDEF HAVE_MKTEMP_DECL
extern  char *mktemp(char *template);
#Эндиф

#IFNDEF HAVE_MKSTEMP_DECL
extern int mkstemp(char *template);
#Эндиф

#IFNDEF HAVE_MKTIME_DECL
extern time_t mktime(struct tm *timeptr);
#Эндиф

#IFNDEF HAVE_OPENLOG_DECL
#Ифдеф LOG_AUTH
extern void openlog(const char *ident, int logopt, int facility);
#еще
extern void openlog(const char *ident, int logopt);
#Эндиф
#Эндиф

#IFNDEF HAVE_PCLOSE_DECL
extern int pclose(FILE *stream);
#Эндиф

#IFNDEF HAVE_PERROR_DECL
extern void perror(const char *s);
#Эндиф

#IFNDEF HAVE_PRINTF_DECL
extern int printf(const char *format, ...);
#Эндиф

#IFNDEF HAVE_PUTS_DECL
extern int puts(const char *s);
#Эндиф

#IFNDEF HAVE_REALLOC_DECL
внешняя пустота *realloc(void *ptr, size_t размер);
#Эндиф

/* AIX #defines recvfrom и предоставляет прототип альтернативного имени */
#if !defined(HAVE_RECVFROM_DECL) && !defined(recvfrom)
extern  int recvfrom(int s, char *buf, int len, int flags, 
		       struct sockaddr *from, socklen_t_equiv *fromlen);
#Эндиф

#IFNDEF HAVE_REMOVE_DECL
extern int remove(const char *path);
#Эндиф

#IFNDEF HAVE_RENAME_DECL
extern int rename(const char *old, const char *new);
#Эндиф

#IFNDEF HAVE_REWIND_DECL
перемотка пустоты extern (FILE *stream);
#Эндиф

#IFNDEF HAVE_RUSEROK_DECL
extern int ruserok(const char *rhost, int suser,
		      const  char *ruser, const char *luser);
#Эндиф

#IFNDEF HAVE_SELECT_DECL
extern int select(int nfds,
		     SELECT_ARG_TYPE *readfds,
		     SELECT_ARG_TYPE *writefds,
 SELECT_ARG_TYPE *за исключением,
		     struct timeval *timeout);
#Эндиф

#IFNDEF HAVE_SENDTO_DECL
extern int sendto(int s, const char *msg, int len, int flags, 
		     const struct sockaddr *to, int tolen);
#Эндиф

#Ифдеф HAVE_SETRESGID
#Определим setegid(x) setresgid((gid_t)-1,(x),(gid_t)-1)
#IFNDEF HAVE_SETRESGID_DECL
extern int setresgid(gid_t rgid, gid_t egid, gid_t sgid);
#Эндиф
#еще
#IFNDEF HAVE_SETEGID_DECL
extern int setegid(gid_t egid);
#Эндиф
#Эндиф

#Ифдеф HAVE_SETRESUID
#Определим seteuid(x) setresuid((uid_t)-1,(x),(uid_t)-1)
#IFNDEF HAVE_SETRESUID_DECL
extern int setresuid(uid_t ruid, uid_t euid, uid_t suid);
#Эндиф
#еще
#IFNDEF HAVE_SETEUID_DECL
extern int seteuid(uid_t euid);
#Эндиф
#Эндиф

#IFNDEF HAVE_SETPGID_DECL
#Ифдеф HAVE_SETPGID
extern int setpgid(pid_t PID, pid_t PGID);
#Эндиф
#Эндиф

#IFNDEF HAVE_SETPGRP_DECL
#Ифдеф SETPGRP_VOID
extern pid_t setpgrp(void);
#еще
extern pid_t setpgrp(pid_t pgrp, pid_t PID);
#Эндиф
#Эндиф

#IFNDEF HAVE_SETSOCKOPT_DECL
extern  int setsockopt(int s, int level, int optname, 
			 const char *optval, int optlen);
#Эндиф

#Ифдеф HAVE_SHMGET
#IFNDEF HAVE_SHMAT_DECL
extern void *shmat(int shmid, const SHM_ARG_TYPE *shmaddr, int shmflg);
#Эндиф

#IFNDEF HAVE_SHMCTL_DECL
extern  int shmctl(int shmid, int cmd, struct shmid_ds *buf);
#Эндиф

#IFNDEF HAVE_SHMDT_DECL
extern int shmdt(SHM_ARG_TYPE *shaddr);
#Эндиф

#IFNDEF HAVE_SHMGET_DECL
extern int shmget(key_t ключ, size_t size, int shmflg);
#Эндиф
#Эндиф

#IFNDEF HAVE_SNPRINTF_DECL
int snprintf(char *buf, size_t len, const char *format,...)
 G_GNUC_PRINTF(3,4);
#Эндиф
#IFNDEF HAVE_VSNPRINTF_DECL
int vsnprintf(char *buf, size_t len, const char *format, va_list AP);
#Эндиф

#IFNDEF HAVE_SOCKET_DECL
extern int socket(int domain, int type, int protocol);
#Эндиф

#IFNDEF HAVE_SOCKETPAIR_DECL
extern int socketpair(int domain, int type, int protocol, int sv[2 ]);
#Эндиф

#IFNDEF HAVE_SSCANF_DECL
extern int sscanf(const char *s, const char *format, ...);
#Эндиф

#IFNDEF HAVE_STRCASECMP_DECL
extern int strcasecmp(const char *s1, const char *s2);
#Эндиф

#IFNDEF HAVE_STRERROR_DECL
extern char *strerror(int errnum);
#Эндиф

#IFNDEF HAVE_STRFTIME_DECL
extern size_t strftime(char *s, size_t maxsize, const char *format,
			  const struct tm *timeptr);
#Эндиф

#IFNDEF HAVE_STRNCASECMP_DECL
extern int strncasecmp(const char *s1, const char *s2, int n);
#Эндиф

#IFNDEF HAVE_SYSLOG_DECL
extern void syslog(int priority, const char *logstring, ...)
 G_GNUC_PRINTF(2,3);
#Эндиф

#IFNDEF HAVE_SYSTEM_DECL
extern int system(const char *string);
#Эндиф

#IFNDEF HAVE_TIME_DECL
extern time_t time(time_t *tloc);
#Эндиф

#IFNDEF HAVE_TOLOWER_DECL
extern  int tolower(int c);
#Эндиф

#IFNDEF HAVE_TOUPPER_DECL
extern  int toupper(int c);
#Эндиф

#IFNDEF HAVE_UNGETC_DECL
extern  int ungetc(int c, FILE *stream);
#Эндиф

#IFNDEF HAVE_VFPRINTF_DECL
extern int vfprintf(FILE *stream, const char *format, va_list ap);
#Эндиф

#IFNDEF HAVE_VPRINTF_DECL
extern int vprintf(const char *format, va_list ap);
#Эндиф

/* Эти системные заголовки добавляются gnulib, если они
 * не существуют */
#Включите "netdb.h"
#Включите "arpa/inet.h"

/* gnulib-only включает */
#Включите "safe-read.h"
#Включите "full-read.h"
#Включите "full-write.h"

#if !defined(S_ISCHR) && defined(_S_IFCHR) && defined(_S_IFMT)
#Определите S_ISCHR(режим) (((режим) & _S_IFMT) == _S_IFCHR)
#Эндиф

#if !defined(S_ISREG) && defined(_S_IFREG) && defined(_S_IFMT)
#Определите S_ISREG(режим) (((режим) & _S_IFMT) == _S_IFREG)
#Эндиф

#IFNDEF HAVE_WAITPID
#Ифдеф HAVE_WAIT4
#Определите waitpid(pid;status;options) wait4(pid;status;options;0)
#еще
extern pid_t waitpid(pid_t pid, amwait_t *stat_loc, int options);
#Эндиф
#Эндиф

#IFNDEF HAVE_WRITEV_DECL
extern ssize_t writev(int fd, const struct iovec *iov, int iovcnt);
#Эндиф

#IFNDEF STDIN_FILENO
#Определите STDIN_FILENO 0
#Эндиф

#IFNDEF STDOUT_FILENO
#Определите STDOUT_FILENO 1
#Эндиф

#IFNDEF STDERR_FILENO
#Определите STDERR_FILENO 2
#Эндиф

/* S_ISDIR не определен на Nextstep*/
#IFNDEF S_ISDIR
#если определено(_S_IFMT) && определено(_S_IFDIR)
#Определите S_ISDIR(режим) (((режим) & (_S_IFMT)) == (_S_IFDIR))
#еще
#ошибка Не знаю, как определить S_ISDIR
#Эндиф
#Эндиф

#если SIZEOF_SIZE_T == SIZEOF_INT
#  Определение SIZE_T_ATOI (size_t)atoi
#  IFNDEF SIZE_MAX
#    Определите SIZE_MAX G_MAXUINT
#  endif
#else
#  define        SIZE_T_ATOI	(size_t)atol
#  ifndef SIZE_MAX
#    define      SIZE_MAX	ULONG_MAX
#  endif
#endif

#if SIZEOF_SSIZE_T == SIZEOF_INT
#  define        SSIZE_T_ATOI	(ssize_t)atoi
#  ifndef SSIZE_MAX
#    define      SSIZE_MAX	INT_MAX
#  endif
#  ifndef SSIZE_MIN
#    define      SSIZE_MIN	INT_MIN
#  endif
#else
#  define        SSIZE_T_ATOI	(ssize_t)atol
#  ifndef SSIZE_MAX
#    define      SSIZE_MAX	LONG_MAX
#  endif
#  ifndef SSIZE_MIN
#    define      SSIZE_MIN	LONG_MIN
#  endif
#endif

#if SIZEOF_TIME_T == SIZEOF_INT
#  define        TIME_T_ATOI	(time_t)atoi
#  ifndef TIME_MAX
#    define      TIME_MAX	G_MAXUINT
#  endif
#else
#  define        TIME_T_ATOI	(time_t)atol
#  ifndef TIME_MAX
#    define      TIME_MAX	ULONG_MAX
#  endif
#endif

#if SIZEOF_OFF_T > SIZEOF_LONG
#  ifdef HAVE_ATOLL
#    define        OFF_T_ATOI	 (off_t)atoll
#  else
#    define        OFF_T_ATOI	 (off_t)atol
#  endif
#  ifdef HAVE_STRTOLL
#    define        OFF_T_STRTOL	 (off_t)strtoll
#  else
#    define        OFF_T_STRTOL	 (off_t)strtol
#  endif
#else
#  if SIZEOF_OFF_T == SIZEOF_LONG
#    define        OFF_T_ATOI	 (off_t)atol
#    define        OFF_T_STRTOL	 (off_t)strtol
#  else
#    define        OFF_T_ATOI	 (off_t)atoi
#    define        OFF_T_STRTOL	 (off_t)strtol
#  endif
#endif

#define BIND_CYCLE_RETRIES	120		/* Total of 30 minutes */

#ifndef NI_MAXHOST
#define NI_MAXHOST 1025
#endif

typedef enum {
    KENCRYPT_NONE,	/* krb5 encryption not enabled */
 KENCRYPT_WILL_DO, /* Шифрование krb5 будет включено после того, как amanda
 Поток протокола закрыт */
 KENCRYPT_YES /* Шифрование krb5 включено для всех потоков */
} kencrypt_type;

#Определите DUMP_LEVELS 400

/* Константы для определения количества предварительно открытых входов между amandad и
 * его услуги */

/* Если вы измените их, измените их и в perl/Amanda/Constants.pm.in.src */
#Определите DATA_FD_COUNT 5 /* количество входов общего назначения*/ 
#Определите  DATA_FD_OFFSET 150 /* Не меняйте его */ 

#endif /* ! AMANDA_H */

