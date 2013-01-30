# Requirements
#sudo apt-get install libcurl4-gnutls-dev # for RCurl on linux
#install.packages('RCurl')
#install.packages('RJSONIO')

library('RCurl')
library('RJSONIO')

query <- function(querystring) {
  h = basicTextGatherer()
  curlPerform(url="http://localhost:7474/db/data/ext/CypherPlugin/graphdb/execute_query",
    postfields=paste('query',curlEscape(querystring), sep='='),
    writefunction = h$update,
    verbose = FALSE
  )
            
  result <- fromJSON(h$value())

  data <- data.frame(t(sapply(result$data, unlist)))
  names(data) <- result.json$columns
  
  data
  
}

# EXAMPLE
# =======

# Cypher query
q <- "
START root = (0)
MATCH (root)-[:CommentType]->(comments)<-[:HasType]-(comment)-[:PartOf]->(submission)-[:PartOf]->(subreddit)
RETURN comment.ups, comment.downs, submission.ups, submission.downs, subreddit.label, submission.created, comment.created
"

data <- query(q)
head(data)
top_subreddits <- data.frame(table(data$subreddit.label))
top_subreddits[order(top_subreddits$Freq, decreasing=T),]

# OUTPUT:

  submission.ups submission.created comment.downs subreddit.label comment.ups submission.downs
1             33         1307643497             0  TheoryOfReddit           5                9
2           6375         1307723661             0       worldnews           6             4599
3              7         1307832288             1            IAmA           3                4
4              7         1307749193             0     semanticweb           1                3
5             84         1307979471             0       worldnews           1               29
6             19         1308051068             0         belgium           5                4
  comment.created
1      1307691304
2      1307744384
3      1307908788
4      1307910667
5      1308049417
6      1308058498
                  Var1 Freq
25          TrueReddit    9
4     AskSocialScience    7
11                IAmA    7
5              belgium    6
9       Foodforthought    6
15            politics    6
26              videos    5
2            AskReddit    4
17              Python    4
20         semanticweb    4
16         programming    3
22          statistics    3
27           worldnews    3
14                pics    2
18          reddit.com    2
19             Scholar    2
23            Terraria    2
24      TheoryOfReddit    2
1   academicpublishing    1
3           askscience    1
6               bestof    1
7             buildapc    1
8                Drugs    1
10               greed    1
12          MensRights    1
13 PhilosophyofScience    1
21           sociology    1
28                 WTF    1