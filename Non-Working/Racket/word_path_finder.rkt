#lang racket
(require racket/file)  ; For file operations

(define (string->symbol str) (string->symbol str))
(define (symbol->string sym) (symbol->string sym))

; Load words from file (your function)
(define (load-word-list file-path)
  (with-handlers ([exn:fail? (lambda (e)
                            (printf "Error: Could not load word list from ~a~n" file-path)
                            (printf "~a~n" (exn-message e))
                            null)])
    (let ([words (string-split (file->string file-path))])
      (printf "Successfully loaded ~a words from ~a~n~n"
              (length words)
              file-path)
      words)))

; Select random words (your function)
(define (select-random-words word-list)
  (let* ([idx1 (random (length word-list))]
         [idx2 (let loop ()
                 (let ([i (random (length word-list))])
                   (if (= i idx1)
                       (loop)
                       i)))]
         [start-word (list-ref word-list idx1)]
         [target-word (list-ref word-list idx2)])
    (printf "Selected words:~n")
    (printf "  Start:  ~a~n" start-word)
    (printf "  Target: ~a~n~n" target-word)
    (cons start-word target-word)))


(define (one-letter-diff? word1 word2)
  (and (= (string-length word1) (string-length word2))
       (= 1 (count #t (map char=? (string->list word1) (string->list word2))))))

(define (find-path word-list start-word target-word)
  (let ([word-set (set (map string->symbol word-list))])
    (letrec ([find-path-recursive (lambda (current-word path)
                                    (cond
                                      [(equal? current-word target-word) (reverse (cons current-word path))]
                                      [else
                                       (for/fold ([shortest-path #f]) ([neighbor (filter (lambda (w) (one-letter-diff? (symbol->string current-word) (symbol->string w))) (set->list word-set))])
                                         (let ([new-path (find-path-recursive neighbor (cons current-word path))])
                                           (cond
                                             [(and new-path (or (not shortest-path) (< (length new-path) (length shortest-path)))) new-path]
                                             [else shortest-path])))]))])
      (find-path-recursive (string->symbol start-word) null))))


(define (main filename)
  (let ([word-list (load-word-list filename)])  ; Load the word list
    (if (null? word-list)  ; Check if loading failed
        (printf "Word list loading failed. Exiting.~n")
        (let ([start-target (select-random-words word-list)])  ; Select random words
          (let ([start-word (car start-target)]
                [target-word (cdr start-target)])
            (let ([path (find-path word-list start-word target-word)])
              (cond
                [path
                 (printf "Path found! Steps: ~a\n" (- (length path) 1))
                 (for ([word path]) (printf "~a\n" (symbol->string word)))]
                [else
                 (printf "No path found between ~a and ~a.\n" start-word target-word)])))))))

; Example usage (assuming words.txt exists in the same directory):
(main "TWL4CRLF.txt")