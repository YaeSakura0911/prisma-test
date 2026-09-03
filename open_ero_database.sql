-- 启用 PGroonga 扩展
CREATE EXTENSION IF NOT EXISTS pgroonga;

/* ==============================
            语言字典表
============================== */
CREATE TABLE locale (
  code TEXT PRIMARY KEY
);

-- 插入常用 ISO 639-1 语言代码
INSERT INTO locale (code) VALUES ('ja'), ('zh'), ('en');

-- 插入注释
COMMENT ON COLUMN locale.code IS 'ISO 639-1 语言代码';

/* ==============================
            品牌表
============================== */
CREATE TABLE brand (
  id            SERIAL PRIMARY KEY,
  original_name TEXT NOT NULL UNIQUE,
  official_url  TEXT,
  logo_url      TEXT,
  created_at    TIMESTAMP DEFAULT now()
);

COMMENT ON COLUMN brand.id IS '品牌ID';
COMMENT ON COLUMN brand.original_name IS '品牌名称';
COMMENT ON COLUMN brand.official_url IS '官方网址';
COMMENT ON COLUMN brand.logo_url IS 'Logo网址';
COMMENT ON COLUMN brand.created_at IS '创建时间';

/* ==============================
            动画表
============================== */
CREATE TABLE anime (
  id            SERIAL PRIMARY KEY,
  brand_id      INT REFERENCES brand(id),
  original_name TEXT UNIQUE NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT now()
);

-- 插入注释
COMMENT ON COLUMN anime.id IS '动画ID';
COMMENT ON COLUMN anime.brand_id IS '品牌ID';
COMMENT ON COLUMN anime.original_name IS '原始动画名称';
COMMENT ON COLUMN anime.created_at IS '创建时间';

/* ==============================
            动画翻译表
============================== */
CREATE TABLE anime_translation (
  anime_id    INT NOT NULL REFERENCES anime(id),
  locale_code TEXT NOT NULL REFERENCES locale(code) ON UPDATE CASCADE,
  translated_name       TEXT,
  translated_overview    TEXT,
  PRIMARY KEY (anime_id, locale_code)
);

-- 创建索引
CREATE INDEX idx_anime_translation_locale
    ON anime_translation (locale_code);
CREATE INDEX idx_anime_translation_translated_name
    ON anime_translation
    USING pgroonga (translated_name)
    WITH (tokenizer='TokenMecab');
CREATE INDEX idx_anime_translation_translated_overview
    ON anime_translation
    USING pgroonga (translated_overview);
CREATE INDEX idx_anime_translation_all
    ON anime_translation
    USING pgroonga (translated_name, translated_overview);

-- 添加注释
COMMENT ON COLUMN anime_translation.anime_id IS '动画ID';
COMMENT ON COLUMN anime_translation.locale_code IS 'ISO 639-1 语言代码';
COMMENT ON COLUMN anime_translation.translated_name IS '国际化名称';
COMMENT ON COLUMN anime_translation.translated_overview IS '国际化概述';

/* ==============================
            剧集表
============================== */
CREATE TABLE episode (
  id             SERIAL PRIMARY KEY,
  anime_id       INT REFERENCES anime(id),
  original_name  TEXT NOT NULL,
  product_code   TEXT UNIQUE,
  air_date       DATE NOT NULL,
  season_number  INT NOT NULL,
  episode_number INT NOT NULL,
  official_url   TEXT NOT NULL,
  cover_url      TEXT,
  poster_url     TEXT,
  preview_urls   TEXT[],
  duration       INT,
  created_at     TIMESTAMP NOT NULL DEFAULT now(),
  UNIQUE (anime_id, season_number, episode_number)
);

-- 添加注释
COMMENT ON COLUMN episode.id IS '剧集ID';
COMMENT ON COLUMN episode.anime_id IS '动画ID';
COMMENT ON COLUMN episode.original_name IS '原始剧集名称';
COMMENT ON COLUMN episode.product_code IS '代号';
COMMENT ON COLUMN episode.air_date IS '发布日期';
COMMENT ON COLUMN episode.season_number IS '季号';
COMMENT ON COLUMN episode.episode_number IS '集号';
COMMENT ON COLUMN episode.official_url IS '官方网址';
COMMENT ON COLUMN episode.cover_url IS '封面网址';
COMMENT ON COLUMN episode.poster_url IS '海报网址';
COMMENT ON COLUMN episode.preview_urls IS '预览图网址';
COMMENT ON COLUMN episode.duration IS '时长';

/* ==============================
            剧集翻译表
============================== */
CREATE TABLE episode_translation (
    episode_id  INT NOT NULL REFERENCES episode(id),
    locale_code TEXT NOT NULL REFERENCES locale(code),
    translated_name       TEXT,
    translated_overview    TEXT,
    PRIMARY KEY (episode_id, locale_code)
);

-- 创建索引
CREATE INDEX idx_episode_translation_locale
    ON episode_translation (locale_code);
CREATE INDEX idx_episode_translation_alias
    ON episode_translation
    USING pgroonga (translated_name)
    WITH (tokenizer='TokenMecab');
CREATE INDEX idx_episode_translation_overview
    ON episode_translation
    USING pgroonga (translated_overview);
CREATE INDEX idx_episode_translation_all
    ON episode_translation
    USING pgroonga (translated_name, translated_overview);

-- 添加注释
COMMENT ON COLUMN episode_translation.episode_id IS '剧集ID';
COMMENT ON COLUMN episode_translation.locale_code IS 'ISO 639-1 语言代码';
COMMENT ON COLUMN episode_translation.translated_name IS '国际化名称';
COMMENT ON COLUMN episode_translation.translated_overview IS '国际化名称';

/* ==============================
            标签表
============================== */
CREATE TABLE tag (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- 添加注释
COMMENT ON COLUMN tag.id IS '标签ID';
COMMENT ON COLUMN tag.name IS '标签名称';
COMMENT ON COLUMN tag.created_at IS '创建时间';

/* ==============================
            角色表
============================== */
CREATE TABLE character (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- 添加注释
COMMENT ON COLUMN character.id IS '角色ID';
COMMENT ON COLUMN character.name IS '角色名称';
COMMENT ON COLUMN character.created_at IS '创建时间';

/* ==============================
            人物表
============================== */
CREATE TABLE person (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- 添加注释
COMMENT ON COLUMN person.id IS '人物ID';
COMMENT ON COLUMN person.name IS '人物名称';
COMMENT ON COLUMN person.created_at IS '创建时间';

/* ==============================
            职位表
============================== */
CREATE TABLE position (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- 添加注释
COMMENT ON COLUMN position.id IS '职位ID';
COMMENT ON COLUMN position.name IS '职位名称';
COMMENT ON COLUMN position.created_at IS '创建时间';

/* ==============================
        剧集标签关联表
============================== */
CREATE TABLE episode_tag (
  episode_id INT REFERENCES episode(id),
  tag_id     INT REFERENCES tag(id),
  PRIMARY KEY (episode_id, tag_id)
);

-- 添加注释
COMMENT ON COLUMN episode_tag.episode_id IS '剧集ID';
COMMENT ON COLUMN episode_tag.tag_id IS '标签ID';

/* ==============================
        动画角色关联表
============================== */
CREATE TABLE anime_character (
  anime_id     INT REFERENCES anime(id),
  character_id INT REFERENCES character(id),
  person_id    INT REFERENCES person(id),
  PRIMARY KEY (anime_id, character_id, person_id)
);

-- 添加注释
COMMENT ON COLUMN anime_character.anime_id IS '动画ID';
COMMENT ON COLUMN anime_character.character_id IS '角色ID';
COMMENT ON COLUMN anime_character.person_id IS '人物ID';

/* ==============================
        动画职员关联表
============================== */
CREATE TABLE anime_staff (
  anime_id    INT REFERENCES anime(id),
  person_id   INT REFERENCES person(id),
  position_id INT REFERENCES position(id),
  PRIMARY KEY (anime_id, person_id, position_id)
);

-- 添加注释
COMMENT ON COLUMN anime_staff.anime_id IS '动画ID';
COMMENT ON COLUMN anime_staff.person_id IS '人物ID';
COMMENT ON COLUMN anime_staff.position_id IS '职位ID';