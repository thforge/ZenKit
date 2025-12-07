include(CheckSymbolExists)
include(CheckCSourceCompiles)

function(bs_check_posix_mmap _MMAP_AVAIL)
    check_c_source_compiles("
    #include <sys/fcntl.h>
    #include <sys/mman.h>
    #include <sys/stat.h>
    #include <unistd.h>
    int main(int argc, char** argv) {
		int handle = open(argv[1], O_RDONLY);
		struct stat st;
		fstat(handle, &st);
		void* data = mmap(NULL, st.st_size, PROT_READ, MAP_SHARED, handle, 0);
		close(handle);
        munmap(data, st.st_size);
        return 0;
    }" _HAS_POSIX_MMAP)

    # return _HAS_POSIX_MMAP
    set(${_MMAP_AVAIL} ${_HAS_POSIX_MMAP} PARENT_SCOPE)
    return()
endfunction()

function(bs_check_win32_mmap _MMAP_AVAIL)
    check_c_source_compiles("
    #include <windows.h>
    int main(int argc, char** argv) {
        HANDLE hFile = CreateFile(L\"test.txt\", GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        DWORD dwFileSize = GetFileSize(hFile, NULL);
        HANDLE hFileMapping = CreateFileMapping(hFile, NULL, PAGE_READONLY, 0, dwFileSize, NULL);
        LPVOID lpFileBase = MapViewOfFile(hFileMapping, FILE_MAP_READ, 0, 0, 0);
        return 0;
    }" _HAS_WIN32_MMAP)

    # return _HAS_WIN32_MMAP
    set(${_MMAP_AVAIL} ${_HAS_WIN32_MMAP} PARENT_SCOPE)
    return()
endfunction()
