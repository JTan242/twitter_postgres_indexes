CREATE INDEX ON tweet_tags (tag, id_tweets);
CREATE INDEX ON tweets USING GIN (to_tsvector('english', text));
CREATE INDEX ON tweets (lang);
CREATE INDEX ON tweets (id_tweets, lang);
CREATE INDEX ON tweets(id_tweets);
/*
 * dropped tweets and tweet_tags views and replaced with materialized views
 *
 * New Code:
 *
 * CREATE MATERIALIZED VIEW tweets AS (
    SELECT
        data->>'id' AS id_tweets,
        data->'user'->>'id' AS id_users,
        (data->>'created_at') :: TIMESTAMPTZ AS created_at,
        data->>'in_reply_to_status_id' AS in_reply_to_status_id,
        data->>'in_reply_to_user_id' AS in_reply_to_user_id,
        data->>'quoted_status_id' AS quoted_status_id,
        'FIXME' AS geo_coords,
        'FIXME' AS geo_string,
        data->>'retweet_count' AS retweet_count,
        data->>'quote_count' AS quote_count,
        data->>'favorite_count' AS favorite_count,
        data->>'withheld_copyright' AS withheld_copyright,
        data->'withheld_in_countries' AS withheld_in_countries,
        data->'place'->>'full_name' AS place_name,
        lower(data->'place'->>'country_code') AS country_code,
        'FIXME' AS state_code,
        data->>'lang' AS lang,
        COALESCE(data->'extended_tweet'->>'full_text',data->>'text') AS text,
        data->>'source' AS source
    FROM tweets_jsonb
);

CREATE MATERIALIZED VIEW tweet_tags AS (
    SELECT DISTINCT id_tweets, '$' || (jsonb->>'text'::TEXT) AS tag
    FROM (
        SELECT
            data->>'id' AS id_tweets,
            jsonb_array_elements(
                COALESCE(data->'entities'->'symbols','[]') ||
                COALESCE(data->'extended_tweet'->'entities'->'symbols','[]')
            ) AS jsonb
        FROM tweets_jsonb
    ) t
    UNION ALL
    SELECT DISTINCT id_tweets, '#' || (jsonb->>'text'::TEXT) AS tag
    FROM (
        SELECT
            data->>'id' AS id_tweets,
            jsonb_array_elements(
                COALESCE(data->'entities'->'hashtags','[]') ||
                COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
            ) AS jsonb
        FROM tweets_jsonb
    ) t
);

*/

