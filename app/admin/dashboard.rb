ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
  thisday =  Date.today.strftime("%Y-%m-%d")

  content :title => "Poll Vote Breakdown - #{thisday}" do
    

    columns do
      column do
        Poll.all.includes(:poll_questions, :poll_answers).each do |p|
          panel link_to("Poll: #{p.title}   -   Total Votes: #{p.chicago_votes.count}", edit_admin_poll_path(p)) do
            h3 "Image Downloads: #{ChicagoVote.where(voteable_type: "PollScene").count + 360}"
            p.poll_questions.each do |pq|
              panel pq.title do
                table_for pq.poll_answers.each do |pa|
                  column("Title"){|pa| pa.title}
                  column("Votes"){|pa| pa.chicago_votes.count}
                  column("Percent"){|pa| pa.vote_percentage}
                end
              end
            end
          end
        end
      end
    end




    # columns do
    #   column do
    #     panel "Top Daily Episodes - #{thisday}" do

            # h4 "Total Video Views Today: #{Visit.where("created_at >= ?", Time.zone.now.beginning_of_day).count}"

            # con = ActiveRecord::Base.connection()

            # sql = "select v.link_id, l.linkedmedia_id as episode_id,  e.title as episode,  count(*) as count from visits as v, links as l, episodes as e  where v.created_at::TEXT like '#{thisday}%' and (v.link_id = l.id) and (e.id = l.linkedmedia_id)  group by e.title, v.link_id, l.id order by count desc limit 10;"

            # result = con.execute(sql)
           
            # if (result.count != 0)
            #     table_for result do |item|
            #         column("Episode") {|item| link_to(item['episode'], edit_admin_episode_path(Episode.find(item['episode_id']))) } 
            #         column("Visits"){ |item| item['count'] } 
            #     end
            # elsif 
            #     h4 "No results found."
            # end   
      #   end
      # end

      # column do
      #   panel "Top Total Episodes" do

            # h4 "Total Video Views: #{Visit.count}"
         
            # con = ActiveRecord::Base.connection()

            # sql2 = "select  l.linkedmedia_id as episode_id,  e.title as episode,  count(*) as count from visits as v, links as l, episodes as e  where  (v.link_id = l.id) and (e.id = l.linkedmedia_id)  group by e.title,  l.id order by count desc limit 10;"

            # result = con.execute(sql2)

            # table_for result do |item|
            #     column("Episode") {|item| link_to(item['episode'], edit_admin_episode_path(Episode.find(item['episode_id']))) } 
            #     column("Visits"){ |item| item['count'] } 
            # end
      #   end
      # end
    # end
    



  end # content
end
