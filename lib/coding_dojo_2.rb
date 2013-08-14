require "coding_dojo_2/version"

module CodingDojo2
  class Potter

    BASE_BOOK_PRICE = 8

    def make_groups(counts)
        groups = []

        counts_array = counts.to_a
        while !counts_array.empty?
            groups << counts_array.map(&:first)
            counts_array = counts_array.map {|tuple| [tuple[0], tuple[1] - 1]}
                                       .select {|tuple| tuple[1] > 0}
        end

        groups.map(&:count)
    end


    def make_counts_map(books)
        counts = Hash.new { |hash, key| hash[key] = 0 }
        books.each {|book_id| counts[book_id] += 1}
        counts
    end

    def calculate(books)
    	return 0 if books.empty?

        counts = make_counts_map(books)

        groups = make_groups(counts)  

        discounts = {
            1 => 1,
            2 => 0.95,
            3 => 0.90,
            4 => 0.8,
            5 => 0.75
        }

        groups.inject(0){|accum, group_count| accum + (discounts[group_count] * group_count * BASE_BOOK_PRICE)}

    end
  end
end
