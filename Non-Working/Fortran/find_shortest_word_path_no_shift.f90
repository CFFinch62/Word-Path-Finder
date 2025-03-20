module word_path_finder
  implicit none

  ! Constants
  integer, parameter :: MAX_WORD_LEN = 4
  integer, parameter :: MAX_PATH_LEN = 100
  integer, parameter :: MAX_QUEUE_SIZE = 10000
  integer, parameter :: MAX_WORDS = 4180

  ! Custom type for result
  type :: PathResult
    logical :: possible
    character(len=MAX_WORD_LEN), allocatable :: path(:)
    integer :: steps
  end type PathResult

  ! Queue item type
  type :: QueueItem
    character(len=MAX_WORD_LEN) :: word
    character(len=MAX_WORD_LEN), allocatable :: path(:)
    integer :: path_length
  end type QueueItem

contains

  function find_shortest_word_path(start_word, target_word, word_list, word_count) result(result)
    character(len=*), intent(in) :: start_word, target_word
    character(len=*), intent(in) :: word_list(:)
    integer, intent(in) :: word_count
    type(PathResult) :: result

    ! Local variables
    type(QueueItem) :: queue(MAX_QUEUE_SIZE)
    character(len=MAX_WORD_LEN) :: visited(MAX_QUEUE_SIZE)
    integer :: queue_size, visited_size
    integer :: i, j, k
    character :: new_letter
    character(len=MAX_WORD_LEN) :: new_word, current_word
    logical :: word_exists, is_visited

    ! Early exit if words are the same
    if (start_word == target_word) then
      result%possible = .true.
      allocate(result%path(1))
      result%path(1) = start_word
      result%steps = 0
      return
    end if

    ! Initialize queue with start word
    queue_size = 1
    visited_size = 1

    allocate(queue(1)%path(1))
    queue(1)%word = start_word
    queue(1)%path(1) = start_word
    queue(1)%path_length = 1

    visited(1) = start_word

    do while (queue_size > 0)
      current_word = queue(1)%word

      ! Try changing each letter position
      do i = 1, len_trim(current_word)
        ! Try each letter A-Z
        do j = 65, 90
          new_letter = achar(j)

          ! Build new word
          new_word = current_word
          new_word(i:i) = new_letter

          ! Check if word exists and not visited
          word_exists = .false.
          is_visited = .false.

          ! Check word list
          do k = 1, word_count
            if (new_word == word_list(k)) then
              word_exists = .true.
              exit
            end if
          end do

          ! Check visited
          do k = 1, visited_size
            if (new_word == visited(k)) then
              is_visited = .true.
              exit
            end if
          end do

          if (word_exists .and. (.not. is_visited)) then
            ! Check if target found
            if (new_word == target_word) then
              result%possible = .true.
              allocate(result%path(queue(1)%path_length + 1))
              result%path(1:queue(1)%path_length) = queue(1)%path(1:queue(1)%path_length)
              result%path(queue(1)%path_length + 1) = new_word
              result%steps = queue(1)%path_length
              return
            end if

            ! Add to queue
            queue_size = queue_size + 1
            visited_size = visited_size + 1

            allocate(queue(queue_size)%path(queue(1)%path_length + 1)
            queue(queue_size)%word = new_word
            queue(queue_size)%path(1:queue(1)%path_length) = queue(1)%path(1:queue(1)%path_length)
            queue(queue_size)%path(queue(1)%path_length + 1) = new_word
            queue(queue_size)%path_length = queue(1)%path_length + 1

            visited(visited_size) = new_word
          end if
        end do
      end do

      ! Remove first item from queue
      do i = 1, queue_size - 1
        queue(i) = queue(i + 1)
      end do
      queue_size = queue_size - 1
    end do

    ! No path found
    result%possible = .false.
    allocate(result%path(0))
    result%steps = -1

  end function find_shortest_word_path

  ! Function to load word list from file
  function load_word_list(file_path, word_count) result(word_list)
    character(len=*), intent(in) :: file_path
    integer, intent(out) :: word_count
    character(len=MAX_WORD_LEN), allocatable :: word_list(:)

    integer :: io_status, unit_num
    character(len=MAX_WORD_LEN) :: word

    allocate(word_list(MAX_WORDS))
    word_count = 0

    open(newunit=unit_num, file=file_path, status='old', action='read', access='sequential', iostat=io_status)

    if (io_status /= 0) then
      print *, "Error opening file: ", file_path
      return
    end if

    do while (.true.)
      read(unit_num, '(A)', iostat=io_status) word
      if (io_status /= 0) exit
      word_count = word_count + 1
      word_list(word_count) = word
    end do

    close(unit_num)

    print *, "Successfully loaded ", word_count, " words from ", trim(file_path)
    print *

  end function load_word_list

  ! Function to select random words
  subroutine select_random_words(word_list, word_count, word_length, start_word, target_word, success)
    character(len=*), intent(in) :: word_list(:)
    integer, intent(in) :: word_count, word_length
    character(len=*), intent(out) :: start_word, target_word
    logical, intent(out) :: success

    integer :: valid_count, rand_idx1, rand_idx2
    integer, allocatable :: valid_indices(:)
    real :: r
    integer :: i

    allocate(valid_indices(word_count))
    valid_count = 0

    ! Find words of correct length
    do i = 1, word_count
      if (len_trim(word_list(i)) == word_length) then
        valid_count = valid_count + 1
        valid_indices(valid_count) = i
      end if
    end do

    if (valid_count < 2) then
      print *, "Error: Not enough words of length ", word_length
      success = .false.
      return
    end if

    ! Select two different random words
    call random_number(r)
    rand_idx1 = int(r * valid_count) + 1

    do
      call random_number(r)
      rand_idx2 = int(r * valid_count) + 1
      if (rand_idx2 /= rand_idx1) exit
    end do

    start_word = word_list(valid_indices(rand_idx1))
    target_word = word_list(valid_indices(rand_idx2))

    print *, "Selected words:"
    print *, "  Start:  ", trim(start_word)
    print *, "  Target: ", trim(target_word)
    print *

    success = .true.

  end subroutine select_random_words

end module word_path_finder

! Main program example
program main
  use word_path_finder
  implicit none

  character(len=MAX_WORD_LEN), allocatable :: word_list(:)
  type(PathResult) :: result
  character(len=MAX_WORD_LEN) :: start_word, target_word
  integer :: i, word_count
  logical :: success

  ! Initialize random seed
  call random_seed()

  ! Load word list
  word_list = load_word_list("TWL4LF.txt", word_count)

  ! Select random words
  call select_random_words(word_list, word_count, 4, start_word, target_word, success)

  if (success) then
    ! Find path
    result = find_shortest_word_path(start_word, target_word, word_list, word_count)

    if (result%possible) then
      print *, "Found path with ", result%steps, " steps:"
      do i = 1, size(result%path)
        if (i > 1) write(*, '(A)', advance='no') " -> "
        write(*, '(A)', advance='no') trim(result%path(i))
      end do
      print *
    else
      print *, "No path found between ", trim(start_word), " and ", trim(target_word)
    end if
  end if

end program main
