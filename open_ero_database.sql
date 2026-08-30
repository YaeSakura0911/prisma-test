/*
==================================================
品牌 (Brands) 表
==================================================
*/
DROP TABLE IF EXISTS brands CASCADE;
CREATE TABLE brands (
    id SERIAL PRIMARY KEY,                                         -- 品牌ID
    names JSONB NOT NULL,                                          -- 品牌名称 (如: {"ja":"ピンクパイナップル", "en":"Pink Pineapple"})
    logo_url VARCHAR(255),                                         -- 品牌Logo URL
    website_url VARCHAR(255),                                      -- 公司官网 URL
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP  -- 创建时间
);
-- CREATE INDEX idx_brands_names_gin ON brands USING gin (names);     -- 为品牌名称创建 GIN 索引，方便按名称检索

/*
==================================================
标签 (Tags) 表
==================================================
*/
DROP TABLE IF EXISTS tags CASCADE;
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,            -- 标签ID
    name VARCHAR(100) UNIQUE NOT NULL -- 标签名称 (如: '3D', 'NTR', '异世界')
);

/*
==================================================
里番 (animes) 表
==================================================
*/
DROP TABLE IF EXISTS hanimes CASCADE;
CREATE TABLE animes (
    id SERIAL PRIMARY KEY,                                         -- 里番ID
    brand_id INT REFERENCES brands(id) ON DELETE SET NULL,         -- 品牌方ID
    titles JSONB NOT NULL,                                         -- 里番名称 (如：{"ja":"聖徒会長ヒカル", "en":"Seitokaichou Hikaru"})
    description TEXT,                                              -- 里番简介
    air_date DATE,                                                 -- 发售日期 (如：2026-06)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP  -- 创建时间
);
-- CREATE INDEX idx_hanimes_titles_gin ON animes USING gin (titles); -- 为里番名称创建 GIN 索引，方便按名称检索
-- CREATE INDEX idx_hanimes_brand_id ON animes (brand_id);           -- 为品牌ID创建索引，方便按品牌检索

/*
==================================================
剧集 (Episodes) 表
==================================================
*/
DROP TABLE IF EXISTS episodes CASCADE;
CREATE TABLE episodes (
    id SERIAL PRIMARY KEY,                                   -- 剧集ID
    hanime_id INT REFERENCES hanimes(id) ON DELETE CASCADE,  -- 里番ID
    product_code VARCHAR(100) UNIQUE,                        -- 番号 (如：ACJDP-0084)
    season_number INT DEFAULT 1,                             -- 季号
    episode_number INT NOT NULL,                             -- 集号
    title VARCHAR(255),
    cover_url VARCHAR(255),                                  -- 封面URL
    poster_url VARCHAR(255),                                 -- 海报URL
    preview_urls TEXT[],                                     -- 预览图URL列表 (如：['img1.jpg', 'img2.jpg'])
    duration INT,                                            -- 播放时间 (单位：min)
    air_date DATE,                                           -- 发售日期 (如：2026-06-15)
    UNIQUE (hanime_id, season_number, episode_number)        -- 
);
-- CREATE INDEX idx_episodes_hanime_id ON episodes (hanime_id); -- 为里番ID创建索引，方便按里番检索

/*
==================================================
制作人员 (Staff) 表
==================================================
*/
DROP TABLE IF EXISTS staff CASCADE;
CREATE TABLE staff (
    id SERIAL PRIMARY KEY,      -- 制作人员ID
    name VARCHAR(255) NOT NULL -- 制作人员名称
);

/*
==================================================
职位（Positions）表
==================================================
*/
DROP TABLE IF EXISTS positions CASCADE;
CREATE TABLE positions (
    id SERIAL PRIMARY KEY,                                           -- 职位ID
    names JSONB NOT NULL                                             -- 职位名称 (如: {"ja":"監督", "en":"Director"})
);
-- CREATE INDEX idx_positions_names_gin ON positions USING gin (names); -- 为职位名称创建 GIN 索引，方便按名称检索

/*
==================================================
演员 (Actors) 表
==================================================
*/
DROP TABLE IF EXISTS actors CASCADE;
CREATE TABLE actors (
    id SERIAL PRIMARY KEY,       -- 演员ID
    name VARCHAR(255) NOT NULL  -- 演员名称
);

/*
==================================================
-- 角色 (Characters) 表
==================================================
*/
DROP TABLE IF EXISTS characters CASCADE;
CREATE TABLE characters (
    id SERIAL PRIMARY KEY,      -- 角色ID
    name VARCHAR(255) NOT NULL -- 角色名称
);

/*
==================================================
里番-标签 (hanime_tags) 关联表
==================================================
*/
DROP TABLE IF EXISTS hanime_tags CASCADE;
CREATE TABLE hanime_tags (
    hanime_id INT REFERENCES hanimes(id) ON DELETE CASCADE,  -- 里番ID
    tag_id INT REFERENCES tags(id) ON DELETE CASCADE,        -- 标签ID
    PRIMARY KEY (hanime_id, tag_id)                          -- 联合主键，确保一部里番不会贴上重复标签
);
-- CREATE INDEX idx_hanime_tags_tag_id ON hanime_tags (tag_id); -- 为标签ID创建索引，加速“查找某标签下的所有里番”操作

/*
==================================================
动漫-制作人员 (hanime_staff) 关联表
==================================================
*/
DROP TABLE IF EXISTS hanime_staff CASCADE;
CREATE TABLE hanime_staff (
    id SERIAL PRIMARY KEY,
    hanime_id INT REFERENCES hanimes(id) ON DELETE CASCADE,              -- 里番ID
    staff_id INT REFERENCES staff(id) ON DELETE CASCADE,                 -- 制作人员ID
    position_id INT REFERENCES positions(id) ON DELETE CASCADE,          -- 职位ID
    UNIQUE (hanime_id, staff_id, position_id)                            -- 联合唯一约束，确保同一部里番中同一制作人员不会被分配重复职位
);
-- CREATE INDEX idx_hanime_staff_staff_id ON hanime_staff (staff_id);       -- 为制作人员ID创建索引，加速“查询某人参与过的所有作品”操作
-- CREATE INDEX idx_hanime_staff_position_id ON hanime_staff (position_id); -- 为职位ID创建索引，加速“查询某职位的所有人员”操作

/*
==================================================
里番-角色-演员 (hanime_actor) 关联表
==================================================
*/
DROP TABLE IF EXISTS hanime_actor CASCADE;
CREATE TABLE hanime_actor (
    id SERIAL PRIMARY KEY,
    hanime_id INT REFERENCES hanimes(id) ON DELETE CASCADE,                -- 里番ID
    character_id INT REFERENCES characters(id) ON DELETE CASCADE,          -- 角色ID
    actor_id INT REFERENCES actors(id) ON DELETE CASCADE,                  -- 演员ID
    UNIQUE(hanime_id, character_id, actor_id)                              -- 联合唯一约束，确保同一部里番中同一角色不会被同一演员重复出演
);
-- CREATE INDEX idx_hanime_actor_character_id ON hanime_actor (character_id); -- 为角色ID创建索引，加速“查询某角色的所有出演者”操作
-- CREATE INDEX idx_hanime_actor_actor_id ON hanime_actor (actor_id);         -- 为演员ID创建索引，加速“查询某演员出演过的所有角色”操作