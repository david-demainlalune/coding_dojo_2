require "coding_dojo_2/version"

module CodingDojo2
  class Potter

    BOOK_UNIT_PRICE = 8

    PRICES = {
        1 => 1 * BOOK_UNIT_PRICE ,
        2 => 2 * BOOK_UNIT_PRICE * 0.95,
        3 => 3 * BOOK_UNIT_PRICE * 0.90,
        4 => 4 * BOOK_UNIT_PRICE * 0.8,
        5 => 5 * BOOK_UNIT_PRICE * 0.75
    }

    def array_substract(a1, a2)
        # sub a2 from a1
        result = a1.clone

        a2.each do |val|
            index = result.index(val)
            result.delete_at(index) unless index.nil?
        end

        result
    end

    # recur on a list of possible solutions,
    # where each solution is a tuple [t1 t2] 
    # t1 is the total price of a given set of uniq books 
    # and t2 is the remaining "unsorted" books
    # recursion stops when all solutions have run out of books to classify

    # to pass the last test we use partial brute force: 
    # at each turn, we add the biggest set of uniq books possible S1, 
    # and all combinations of sets with count (S1.count - 1)
    # In other words, if S1 has a count of 5, we add all combinations of 4 elements 
    # taken from S1

    # unoptimized and unidiomatic

    def recur(list_of_solutions)

        done = list_of_solutions.map{|tuple| tuple[1].empty?}.inject {|a, b| a && b}
        return list_of_solutions.map{|tuple| tuple[0]}.min if done

        new_list_of_solutions = []

        list_of_solutions.each do |tuple|
            current_total, remaining_books = tuple

            if remaining_books.empty?
                new_list_of_solutions << tuple
                next
            end

            uniqs = remaining_books.uniq
            new_list_of_solutions << [current_total + PRICES[uniqs.count], 
                                      array_substract(remaining_books, uniqs)]

            combinations_count = uniqs.count - 1
            if (combinations_count > 0)
                combinations = uniqs.combination(combinations_count).to_a

                combinations.each do |combination|
                    new_list_of_solutions << [current_total + PRICES[combinations_count], 
                                              array_substract(remaining_books, combination)]
                end
            end
        end

        recur(new_list_of_solutions)
    end

    def calculate(books)
        recur([[0, books]])
    end

  end
end
