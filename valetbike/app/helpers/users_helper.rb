module UsersHelper
  USER_NUMBER_RANGE=(1_000..9_999)
  def generate_user_id()
    user_id = loop do
      number = rand(USER_NUMBER_RANGE)
      break number unless User.exists?(identifier: number)
    end
    return user_id
  end
end
