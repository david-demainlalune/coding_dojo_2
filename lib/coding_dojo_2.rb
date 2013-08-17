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


    def best_price(solutions)
      solutions.map{|solution| solution[0]}.min
    end

    def done?(solutions)
      solutions.map{|solution| solution[1].empty?}.all?
    end

    def solution_next_step(old_solution, book_group_to_remove)
      current_total, remaining_books = old_solution

      [current_total + PRICES[book_group_to_remove.count], 
       array_substract(remaining_books, book_group_to_remove)]
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

    def recur(solutions)

      return best_price(solutions) if done?(solutions)

      new_solutions = solutions.inject([]) do |new_list, solution|
        remaining_books = solution[1]
        if remaining_books.empty?
          new_list << solution
        else
          uniqs = remaining_books.uniq
          groups = [uniqs] + uniqs.combination(uniqs.count - 1).select{|a| ! a.empty? }
          groups.each {|group| new_list << solution_next_step(solution, group)}
          new_list
        end
      end
      recur(new_solutions)
    end

    def calculate(books)
      recur([[0, books]])
    end

  end
end
