class HomeController < ApplicationController
  include Kamigo::Clients::LineClient

  # before_action :authenticate_user
  def share_bot
  end

  def share_bot_flex
  end

  def missing
    miss = ["我在忙","在想尼阿","在你心裡拉ㄎㄎ"]
    keyword = params[:word]
    if keyword.include? "?" || keyword.include? "勒" || keyword.include? "哩" || keyword.include? "呢" || keyword.include? "ㄋ"
      @iam = miss.sample
    end
  end
      

  def follow
    displayName = params.dig(:profile, :displayName)
    if displayName == "子函"
      @welcom = "哈囉大正妹"
    elsif displayName =="kevin"
      @welcom ="4牛阿娟ㄟ!!"
    else
      @welcom = "你誰ㄚ你"
    end
  end

  def member_join
    @profiles = params.dig(:payload, :joined, :members).map{|member| get_profile(member.dig(:userId)) }
  end

  private

  def get_profile(user_id)
    case params[:source_type]
    when 'group'
      response = client.get_group_member_profile(
        params[:source_group_id],
        user_id
      )
    when 'room'
      response = client.get_room_member_profile(
        params[:source_group_id],
        user_id
      )
    else
      response = client.get_profile(user_id)
    end
    JSON.parse(response.body)
  end
end

