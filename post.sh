echo Hello, Could you write it in the title of the post? : 
read postTitle
cp postTemplate.md _posts/$(date +%Y-%m-%d-)$postTitle.md
mkdir assets/post-img/$postTitle