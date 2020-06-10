module UsersHelper
  def gravatar_for(user, size: 80)
    image_tag "https://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}?size=#{size}",
              alt: user.email,
              class: 'gravatar'
  end
end
