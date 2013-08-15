a = [0, 1, 2, 3, 4]

require 'Set'



discounts = {
    1 => 1,
    2 => 0.95,
    3 => 0.90,
    4 => 0.8,
    5 => 0.75
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

def recur(list_of_structs)

	base_book_price = 8

	prices = {
	    1 => 1 * base_book_price ,
	    2 => 2 * base_book_price * 0.95,
	    3 => 3 * base_book_price * 0.90,
	    4 => 4 * base_book_price * 0.8,
	    5 => 5 * base_book_price * 0.75
	}

	done = list_of_structs.map{|tuple| tuple[1].empty?}.inject {|a, b| a && b}

	if done
		return list_of_structs.map{|tuple| tuple[0]}.min
	end



	new_list_of_structs = []

	list_of_structs.each do |tuple|
		current_total = tuple[0]
		remaining_books = tuple[1]

		if remaining_books.empty?
			new_list_of_structs << [current_total, []]
			next
		end

		uniqs = remaining_books.uniq

		new_list_of_structs << [current_total + prices[uniqs.count], 
								array_substract(remaining_books, uniqs)]


		if (uniqs.count - 1 > 0)
			combinations = uniqs.combination(uniqs.count - 1).to_a

			price_for_combinations_count = prices[uniqs.count - 1]
			combinations.each do |combination|
				new_list_of_structs << [current_total + price_for_combinations_count, 
										array_substract(remaining_books, combination)]
			end

		end

	end

	#puts new_list_of_structs.to_s

	recur(new_list_of_structs)
end

def calculate(books)
	recur([[0, books]])
end

