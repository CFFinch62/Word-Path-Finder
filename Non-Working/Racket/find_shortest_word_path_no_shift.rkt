#lang racket

; Structure definitions
(struct path-result (possible path steps) #:transparent)
(struct queue-item (word path) #:transparent)

; Load words from file
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

; Select random words of specified length
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

; Generate all possible one-letter variations of a word
(define (generate-variations word word-set)
  (let* ([chars (string->list word)]
        [len (length chars)])
    (for*/list ([i (range len)]
               [c (range 97 123)]) ; ASCII values for lowercase a-z
      (let ([new-word (list->string
                       (append (take chars i)
                               (list (integer->char c))
                               (drop chars (add1 i))))])
        (when (set-member? word-set new-word)  ; Check against word list
          new-word)))))

; Find shortest path between words using BFS
(define (find-shortest-path start-word target-word word-list)
  ; Early exit if words are the same
  (if (string=? start-word target-word)
      (path-result #t (list start-word) 0)
      ; Main BFS algorithm
      (let ([word-set (list->set word-list)])
        (let bfs ([queue (list (queue-item start-word (list start-word)))]
                 [visited (set start-word)])
          (if (null? queue)
              ; No path found
              (path-result #f null -1)
              (let* ([current (car queue)]
                     [current-word (queue-item-word current)]
                     [current-path (queue-item-path current)]
                     [variations (filter (λ (w) (and (set-member? word-set w)
                                                    (not (set-member? visited w))))
                                       (generate-variations current-word))])
                ; Check if any variation is the target
                (let ([target-found (findf (λ (w) (string=? w target-word))
                                         variations)])
                  (if target-found
                      ; Found path to target
                      (path-result #t 
                                 (append current-path (list target-found))
                                 (length current-path))
                      ; Continue BFS
                      (let ([new-items (map (λ (w) (queue-item w (append current-path (list w))))
                                          variations)]
                            [new-visited (foldl set-add visited variations)])
                        (bfs (append (cdr queue) new-items)
                             new-visited))))))))))

; Format path for display
(define (format-path path)
  (string-join path " -> "))

; Main program
(module+ main
  (let ([word-list (load-word-list "TWL4LF.txt")])
    (when (not (null? word-list))
      (let ([word-pair (select-random-words word-list)])
        (when word-pair
          (let* ([start-word (car word-pair)]
                 [target-word (cdr word-pair)]
                 [result (find-shortest-path start-word target-word word-list)])
            (if (path-result-possible result)
                (printf "Found path with ~a steps: ~a~n"
                        (path-result-steps result)
                        (format-path (path-result-path result)))
                (printf "No path found between ~a and ~a~n"
                        start-word target-word)))))))) 