module RentalsHelper
  RENTAL_NUMBER_RANGE = (10_000..99_999)

  def generate_rental_id()
    rental_id = loop do
      number = rand(RENTAL_NUMBER_RANGE)
      break number unless Rental.exists?(identifier: number)
    end
    return rental_id
  end
end
