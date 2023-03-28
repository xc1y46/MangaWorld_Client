USE master
GO

IF DB_ID('Project4DB') IS NOT NULL
 DROP DATABASE Project4DB
GO

CREATE DATABASE Project4DB
GO

USE Project4DB
GO

IF  OBJECT_ID('dbo.Language', 'U') IS NOT NULL
  DROP TABLE dbo.[Language]
CREATE TABLE [Language](
	LanguageId NVARCHAR(40) PRIMARY KEY,
	LanguageName NVARCHAR(100) NOT NULL,
	CountryFlag NVARCHAR(255) NULL
)

GO

IF  OBJECT_ID('dbo.Status', 'U') IS NOT NULL
  DROP TABLE dbo.[Status]
CREATE TABLE [Status](
	StatusId NVARCHAR(40) PRIMARY KEY,
	StatusName NVARCHAR(40) NOT NULL
)

GO

IF OBJECT_ID('dbo.Author', 'U') IS NOT NULL
  DROP TABLE dbo.Author
CREATE TABLE Author(
	AuthorId NVARCHAR(40) PRIMARY KEY,
	AuthorName NVARCHAR(255) NOT NULL,
	Biography NVARCHAR(MAX) NULL DEFAULT N'No biography',
	Socials NVARCHAR(MAX) NULL
)

GO

IF OBJECT_ID('dbo.Genre', 'U') IS NOT NULL
  DROP TABLE dbo.Genre
CREATE TABLE Genre(
	GenreId NVARCHAR(40) PRIMARY KEY,
	GenreDescription NVARCHAR(MAX) NULL,
	GenreLevel TINYINT NOT NULL DEFAULT 1
)

GO

IF OBJECT_ID('dbo.ScanTeam', 'U') IS NOT NULL
  DROP TABLE dbo.ScanTeam
CREATE TABLE ScanTeam(
	ScanTeamId NVARCHAR(40) PRIMARY KEY,
	TeamName NVARCHAR(255) NOT NULL,
	TeamDescription NVARCHAR(MAX) NULL,
	TeamSocials NVARCHAR(MAX) NOT NULL,
	LanguageId NVARCHAR(40) FOREIGN KEY REFERENCES [Language](LanguageId) NOT NULL,
	Deleted BIT NOT NULL DEFAULT 0
)

GO

IF OBJECT_ID('dbo.Admin', 'U') IS NOT NULL
  DROP TABLE dbo.[Admin]
CREATE TABLE [Admin](
	AdminId INT PRIMARY KEY IDENTITY (1,1),
	AdminName NVARCHAR(255) NOT NULL,
	AdminPassword NVARCHAR(255) NOT NULL,
	Deleted BIT NOT NULL DEFAULT 0
)

GO

IF OBJECT_ID('dbo.ChapterType', 'U') IS NOT NULL
  DROP TABLE dbo.ChapterType
CREATE TABLE ChapterType(
	ChapterTypeId NVARCHAR(40) PRIMARY KEY,
	ChapterTypeName NVARCHAR(255) NOT NULL
)

GO

IF OBJECT_ID('dbo.Manga', 'U') IS NOT NULL
  DROP TABLE dbo.Manga
CREATE TABLE Manga(
	MangaId NVARCHAR(40) PRIMARY KEY,
	Title NVARCHAR(255) NOT NULL,
	AltTitle NVARCHAR(255) NULL,
	MangaPath NVARCHAR(255) NOT NULL,
	Summary NVARCHAR(MAX) NULL DEFAULT N'No summary',
	AuthorId NVARCHAR(40) FOREIGN KEY REFERENCES Author(AuthorId) NOT NULL,
	Genres NVARCHAR(MAX) NULL,
	LanguageId NVARCHAR(40) FOREIGN KEY REFERENCES [Language](LanguageId) NOT NULL,
	[Status] NVARCHAR(40) FOREIGN KEY REFERENCES [Status](StatusId) NOT NULL DEFAULT N'GO',
	ReleasedYear INT NOT NULL,
	IsPublished BIT NOT NULL DEFAULT 0,
	Deleted BIT NOT NULL DEFAULT 0
)

GO

IF OBJECT_ID('dbo.Chapter', 'U') IS NOT NULL
  DROP TABLE dbo.Chapter
CREATE TABLE Chapter(
	MangaId NVARCHAR(40) FOREIGN KEY REFERENCES Manga(MangaId) NOT NULL,
	ChapterOrder REAL NOT NULL DEFAULT 1,
	ChapterTitle NVARCHAR(225) NOT NULL,
	ChapterTypeId NVARCHAR(40) FOREIGN KEY REFERENCES ChapterType(ChapterTypeId) NOT NULL,
	PageNum INT NOT NULL DEFAULT 0,
	ChapterPath NVARCHAR(255) NULL,
	UploadDate DATETIME NOT NULL,
	ScanTeamId NVARCHAR(40) FOREIGN KEY REFERENCES ScanTeam(ScanTeamId) NOT NULL,
	IsPublished BIT NOT NULL DEFAULT 0,
	Deleted BIT NOT NULL DEFAULT 0
)

GO

IF OBJECT_ID('dbo.User', 'U') IS NOT NULL
  DROP TABLE dbo.[User]
CREATE TABLE [User](
	UserId INT PRIMARY KEY IDENTITY (1,1),
	UserName NVARCHAR(255) NOT NULL,
	UserPassword NVARCHAR(MAX) NOT NULL,
	Bookmarks NVARCHAR(MAX) NULL,
	Deleted BIT NOT NULL DEFAULT 0
)

GO

IF OBJECT_ID('dbo.Rating', 'U') IS NOT NULL
  DROP TABLE dbo.Rating
CREATE TABLE Rating(
	MangaId NVARCHAR(40) FOREIGN KEY REFERENCES Manga(MangaId) NOT NULL,
	UserId INT FOREIGN KEY REFERENCES [User](UserId) NOT NULL,
	Score TINYINT NOT NULL,
)

GO

IF OBJECT_ID('dbo.Comment', 'U') IS NOT NULL
  DROP TABLE dbo.Comment
CREATE TABLE Comment(
	UserId INT FOREIGN KEY REFERENCES [User](UserId) NOT NULL,
	CommentContent NVARCHAR(200) NOT NULL,
	MangaId NVARCHAR(40) FOREIGN KEY REFERENCES Manga(MangaId) NOT NULL,
	CommentDate DATETIME NOT NULL,
)

GO

IF OBJECT_ID('dbo.Report', 'U') IS NOT NULL
  DROP TABLE dbo.Report
CREATE TABLE Report(
	UserId INT FOREIGN KEY REFERENCES [User](UserId) NOT NULL,
	ReportTitle NVARCHAR(100) NOT NULL,
	ReportContent NVARCHAR(200) NOT NULL,
	MangaId NVARCHAR(40) FOREIGN KEY REFERENCES Manga(MangaId) NOT NULL,
	ReportDate DATETIME NOT NULL,
	Resolved BIT NOT NULL DEFAULT 0
)


ON [PRIMARY]
GO

INSERT INTO [Language](LanguageId, LanguageName, CountryFlag) VALUES
(N'VN', N'Vietnamese', N'VN.png'),
(N'EN', N'English', N'EN.png'),
(N'CN', N'Chinese', N'VN.png')

INSERT INTO [Status](StatusId, StatusName) VALUES
(N'GO', N'Ongoing'),
(N'COMP', N'Completed'),
(N'HIA', N'Hiatus'),
(N'CANC', N'Canceled')

INSERT INTO ChapterType(ChapterTypeId, ChapterTypeName) VALUES
(N'NORM', N'Normal chapter'),
(N'ALTN', N'Alternative normal chapter'),
(N'SIDE', N'Side content'),
(N'END', N'End chapter')

INSERT INTO Genre(GenreId, GenreDescription, GenreLevel) VALUES
(N'NOVEL', N'Consist of mostly words paragraph and either none or very little illustrations', 2),
(N'SHOUNEN', N'Targeted at teens and teen boys, sharing common themes of action, adventure', 1),
(N'SHOUJO', N'Targeted at teen girls with romances and drama themes', 1),
(N'KODOMOMUKE', N'Targeted at young children which mostly contains cutesy, moraltisc and fun themes', 1),
(N'COMEDY', N'Cointains mostly of humor, satire and plain ridiculousness', 1),
(N'SLICE OF LIFE', N'Thoughtful portrayals of real daily life along with moderate drama and usually comedy', 1),
(N'FANTASY', N'Multitude of unique fantasy settings and universes outside of reality to explore', 1),
(N'HORROR', N'Frights, chills and thrills abound in comics with creepy and suspense-building stories', 2),
(N'MYSTERY',N'Stories that focus on a puzzling crime, situation, or circumstance that needs to be solved', 1),
(N'DRAMA',N'Themes that deals with serious, often negative, emotions', 1),
(N'ACTION',N'High-octane thrillers that simply aim to give the reader an exciting ride', 1),
(N'ROMANCE',N'Includes stories that have a relationship issue as the main focus', 1),
(N'SCI-FY',N'A genre of fiction literature whose content is imaginative, but based in science', 1),
(N'SPORT',N'Genre that any particular sport plays a prominent role in the plot or acts as its central theme', 1),
(N'4-KOMA',N'Consists of short stories with the 4 panel format per chapter', 1),
(N'SUPERHERO',N'Action and fantasy using superheores as its main theme', 1),
(N'SCHOOL LIFE',N'Focusing on content revolving around the school life experience of students', 1),
(N'SUPERNATURAL',N'A genre of speculative fiction that exploits or is centered on supernatural themes, often contradicting naturalist assumptions of the real world', 1),
(N'MANHUA',N'Chinese comics which was heavily inspired by Japanese manga', 1),
(N'MANHWA',N'Korean comics which was heavily inspired by Japanese manga', 1),
(N'MARTIAL ARTS',N'Action driven stories that have a martial arts theme', 1),
(N'HAREM',N'Focus on polygynous or polyandrous relationships, where a protagonist is surrounded by three or more androphilic/gynephilic suitors, love interests and/or partners', 1),
(N'TRAGEDY',N'A genre of story in which a hero is brought down by his/her own flaws, usually by ordinary human flaws – flaws like greed, over-ambition, or even an excess of love, honor, or loyalty', 1),
(N'ONESHOT', N'A term which implies that the comic is presented in its entirety without any continuation. One-shot manga are often written for contests, and sometimes later developed into a full-length series', 2),
(N'SEINEN', N'Targeted at grown men with adult themes', 2),
(N'SUGGESTIVE',N'Contains slightly or heavily adult contents and themes', 2),
(N'AWARD WINNING',N'Works that have recieved some form of literature award', 3),
(N'GORE',N'Known for its graphic imagery and scenes featuring intense violence', 3)

INSERT INTO Author(AuthorId, AuthorName, Socials, Biography) VALUES
(N'AU_JP_KobaYugo', N'Kobayashi Yuugo',
N'https://ameblo.jp/yugo-kobayashi0503',
N'Kobayashi Yuugo is a Japanese mangaka, who is best known for the work Ao Ashi'
),

(N'AU_JP_TabaYuki', N'Tabata Yuuki',
N'https://www.instagram.com/tabatan_yuki',
N' Before launching his own series, he worked as an assistant to Toshiaki Iwashiro. In 2011, Tabata entered the one-shot Hungry Joker in the Golden Future Cup, which earned first place in the award. This one-shot was later turned into a full series, which ran in Weekly Shōnen Jump from 2012 to 2013. Following Hungry Joker''s completion, Tabata published another one-shot, titled Black Clover, in Shōnen Jump Next!!. This one-shot was later turned into a full series, which started serialization in Weekly Shōnen Jump on February 16, 2015'
),

(N'AU_JP_KaneMune', N'Kaneshiro Muneyuki', NULL, NULL
),

(N'AU_JP_FujiTatsu', N'Fujimoto Tatsuki', 
N'https://twitter.com/nagayama_koharu',
N'Tatsuki Fujimoto is a Japanese manga artist, known for his works Fire Punch and Chainsaw Man.

Fujimoto published his first major and serialized work, Fire Punch, on Shueisha''s Shōnen Jump+ online magazine, where it ran from April 18, 2016, to January 1, 2018. The series spawned eight tankōbon volumes. Fujimoto also published on Shōnen Jump+ the one-shot Me wo Sametara Onnanoko ni Natteita Byou on April 24, 2017, and the one-shot Imouto no Ane in the June 2018 issue of Jump Square on May 2, 2018.

Fujimoto''s second major serialized work, Chainsaw Man, was published in Shueisha''s Weekly Shōnen Jump from December 3, 2018, to December 14, 2020. The series was collected in eleven tankōbon volumes. A sequel to the series is planned to start publishing in Shōnen Jump+. Chainsaw Man topped Takarajimasha''s Kono Manga ga Sugoi! list of best manga of 2021 for male readers and earned Fujimoto the 66th Shogakukan Manga Award for Best Shōnen Manga. In 2021, the manga won the Harvey Awards for Best Manga.'
),

(N'AU_EN_MarvWolf', N'Marv Wolfman',
N'https://www.instagram.com/tabatan_yuki',
N' Marvin Arthur Wolfman (born May 13, 1946) is an American comic book and novelization writer. He worked on Marvel Comics''s The Tomb of Dracula, for which he and artist Gene Colan created the vampire-slayer Blade, and DC Comics''s The New Teen Titans and the Crisis on Infinite Earths limited series with George Pérez. Among the many characters Wolfman created or co-created are Cyborg, Raven, Starfire, Deathstroke, Tim Drake, Rose Wilson, Nova, Black Cat, Bullseye, Vigilante (Adrian Chase) and the Omega Men.'
),

(N'AU_CN_SanShao', N'Tang Jia San Shao',
N'https://weibo.com/1213328234',
N'Tang Jia San Shao is a Chinese online novelist. He is the author of the epic fantasy series Douluo Dalu, also known as Soul Land. It was adapted into the Tencent Penguin Pictures TV series Douluo Dalu (2020), network animation Douluo Dalu (2018–present), as well as comics, online games and mobile games. Most of his other series of fantasy novels are shared universe with Douluo Dalu.

Tang Jia San Shao is one of the representative figures of Chinese online novelists. He has created 24 novels with thousands of copies in print and a total of more than 70 million words since 2004.

Zhang has been listed by some sources as one of China’s top-earning online novelists (2012-2017). In 2015, he was included in Forbes list of Chinese celebrities'
),

(N'AU_CN_TuDou', N'Tian Can Tu Dou',
N'https://weibo.com/1728650035',
N'Li Hu, better known by his pen name Tian Can Tu Dou, is an award-winning Chinese author of IP novels. His most famous work is Fights Break the Sphere, which gained him a large following in 2009. So far 3 of his novels have been adapted to screenplay, as well as manhua and donghua'
),

(N'AU_JP_ToriAkira', N'Toriyama Akira',
N'https://twitter.com/rptoriyama*https://www.instagram.com/akira.toriyama',
N'Akira Toriyama is a Japanese manga artist and character designer. He first achieved mainstream recognition for his highly successful manga series Dr. Slump, before going on to create Dragon Ball—his best-known work—and acting as a character designer for several popular video games such as the Dragon Quest series, Chrono Trigger and Blue Dragon. Toriyama is regarded as one of the artists that changed the history of manga, as his works are highly influential and popular, particularly Dragon Ball, which many manga artists cite as a source of inspiration.

He earned the 1981 Shogakukan Manga Award for best shōnen or shōjo manga with Dr. Slump, and it went on to sell over 35 million copies in Japan. It was adapted into a successful anime series, with a second anime created in 1997, 13 years after the manga ended. His next series, Dragon Ball, would become one of the most popular and successful manga in the world. Having sold 250–300 million copies worldwide, it is the third best-selling manga of all time and is considered to be one of the main reasons for the period when manga circulation was at its highest in the mid-1980s and mid-1990s. Overseas, Dragon Ball''s anime adaptations have been more successful than the manga and are credited with boosting anime''s popularity in the Western world. In 2019, Toriyama was decorated a Chevalier of the French Ordre des Arts et des Lettres for his contributions to the arts'
),

(N'AU_KR_YongJe', N'Park Yong-je',
N'https://www.instagram.com/yongje.park',
N'Yong-Je PARK is best known for being the author & artist of Strongest Fighter and The God of High School'
),

(N'AU_JP_HoriKou', N'Horikoshi Kouhei',
N'https://twitter.com/horikoshiko',
N'Horikoshi first attracted attention in the second half of 2006 when he entered Shueisha''s 72th Tezuka Award for Newcomers with his one shot "Nukegara" and made it to the final six, where he gained himself an "Honorable Mention".
Various short stories in Shueisha''s Akamaru Jump followed over the years until he published his one shot Oumagadoki Doubutsuen in issue #2/2010 of Weekly Shounen Jump. In the same year he got the serialization of this one shot.

After some time he published a new one shot Sensei no Barrage in Jump Next!, and in 2012 he got serialization of it. In this year he gained some popularity also worldwide, like in USA and in Europe.

In 2014 he started Boku no Hero Academia, basing the series on some concepts from an old one-shot, and briefly the series became a very big hit, generating a franchise and winning some national and international prizes'
),

(N'AU_JP_GotoKoyo', N'Gotouge Koyoharu',
N'https://www.instagram.com/koyoharu_gotouge',
N'is a Japanese manga artist, known for the manga series Demon Slayer: Kimetsu no Yaiba (2016–2020). As of February 2021, the manga had over 150 million copies in circulation (including digital copies), making it the ninth best-selling manga series of all time.

She was included as "Phenoms" in Time''s annual list of 100 Most Influential People, becoming the first manga artist to receive the achievement.'
),

(N'AU_JP_FujiTada', N'Fujimaki Tadatoshi',
NULL,
N's a Japanese manga artist, best known as the creator of sports manga Kuroko''s Basketball and golf-based Robot × LaserBeam, both serialized in Weekly Shōnen Jump.'
),

(N'AU_EN_Morris', N'Maurice De Bevere',
NULL,
N'Better known as Morris, was a Belgian cartoonist, comics artist, illustrator and the creator of Lucky Luke, a bestselling comic series about a gunslinger in the American Wild West. He was inspired by the adventures of the historic Dalton Gang and other outlaws. It was a bestselling series for more than 50 years that was translated into 23 languages and published internationally'
),

(N'AU_JP_KishiMasa', N'Kishimoto Masashi',
N'',
N'Masashi Kishimoto is a Japanese manga artist. His best known work, Naruto, was in serialization from 1999 to 2014 and has sold over 250 million copies worldwide in 46 countries as of May 2019. The series has been adapted into two anime and multiple films, video games, and related media. Besides the Naruto manga, Kishimoto also personally supervised the two canonical anime films, The Last: Naruto the Movie and Boruto: Naruto the Movie, and has written several one-shot stories. In 2019, Kishimoto wrote Samurai 8: The Tale of Hachimaru which ended in March 2020. From May 2016 through October 2020 he supervised the Boruto: Naruto Next Generations manga written by Ukyō Kodachi and illustrated by Mikio Ikemoto'
),

(N'AU_CN_Ergen', N'Er gen',
N'https://www.weibo.com/2608040144',
N'Er Gen is a Chinese Web Novel writer whose real name is Liu Yong. Renegade Immortal is his flagship work.'
),

(N'AU_JP_OdaEiichi', N'Oda Eiichiro',
N'https://www.instagram.com/eiichiro.oda*https://www.facebook.com/EiiOdaOnePiece',
N' is a professional manga artist, best known as the creator of the manga One Piece.

A dedicated writer and artist since adolescence, Oda began working for Shueisha''s Shonen Jump at 17. He once worked as an assistant to manga artist such as Kaitani Shinobu, Tokuhiro Masaya, and Watsuki Nobuhiro. He currently stands as one of the world''s most prominent manga artist earning an estimated ¥3.1 billion (US$26 million) per year. Despite his rigorous work schedule, he maintains steady correspondence with fans (and the wider public) through both formal interviews and informal channels such as his SBS columns'
),

(N'AU_JP_MuraYuusuke', N'Murata Yuusuke',
N'https://twitter.com/nebu_kuro',
N'Yusuke Murata is a Japanese manga artist and animator, best known for illustrating One''s One-Punch Man, serialized in the Weekly Young Jump online version.

Murata''s other major work is his illustration of the American football manga Eyeshield 21, in collaboration with writer Riichiro Inagaki. Eyeshield 21 was serialized between July 2002 and June 2009 in Weekly Shōnen Jump, and was later adapted into an anime television series'
),

(N'AU_EN_GregPak', N'Greg Pak',
N'https://www.instagram.com/gregpakpix*https://twitter.com/gregpak',
N'Greg Pak is an American comic book writer and film director. Pak is best known for his work on books published by Marvel Comics, including X-Men (most notably X-Treme X-Men), several titles featuring the Hulk (including Planet Hulk, which was one of the storylines eventually adapted into the film Thor: Ragnarok), and Hercules. In 2019, Pak began writing Star Wars comics for Marvel'
),

(N'AU_EN_CharlesMoulten', N'William Moulton Marston',
NULL,
N'William Moulton Marston, also known by the pen name Charles Moulton, was an American psychologist who, with his wife Elizabeth Holloway, invented an early prototype of the lie detector. He was also known as a self-help author and comic book writer who created the character Wonder Woman'
),

(N'AU_EN_Herge', N'Herge',
NULL,
N'Georges Prosper Remi (22 May 1907 – 3 March 1983), known by the pen name Hergé, from the French pronunciation of his reversed initials RG, was a Belgian cartoonist. He is best known for creating The Adventures of Tintin, the series of comic albums which are considered one of the most popular European comics of the 20th century. He was also responsible for two other well-known series, Quick & Flupke (1930–1940) and The Adventures of Jo, Zette and Jocko (1936–1957). His works were executed in his distinctive ligne claire drawing style'
),

(N'AU_JP_OkadaMari', N'Okada Mari',
N'https://www.instagram.com/marumari_chen',
N'Okada Mari is a Japanese screenwriter, director and manga artist. She is one of the most prolific writers currently working in the anime industry. She won the 16th Animation Kobe Award.'
),

(N'AU_JP_MakoShinkai', N'Makoto Shinkai',
N'https://twitter.com/shinkaimakoto*https://www.instagram.com/makoto.shinkai',
N'Makoto Niitsu, known as Makoto Shinkai, is a Japanese animator, filmmaker, author, and manga artist.

Shinkai began his career as a video game animator with Nihon Falcom in 1996, and gained recognition as a filmmaker with the release of the original video animation (OVA) She and Her Cat (1999). Beginning his longstanding association with CoMix Wave Films, Shinkai then released the science-fiction OVA Voices of a Distant Star in 2002, and followed this with his debut feature film The Place Promised in Our Early Days (2004).'
),

(N'AU_JP_KumoKagyu', N'Kumo Kagyu',
NULL,
N'Kumo Kagyu is known for Goblin Slayer: Goblin''s Crown (2020) and Goblin Slayer (2018).'
),

(N'AU_JP_Shimesaba', N'Shimesaba',
N'https://twitter.com/shimesaba_novel',
NULL
)

INSERT INTO Manga(MangaId, Title, AltTitle, MangaPath, AuthorId, LanguageId, [Status], ReleasedYear, IsPublished, Genres, Summary) VALUES
(N'M_JP_AoAshi', N'Aoashi', N'Ao Ashi', N'\Aoashi', N'AU_JP_KobaYugo', N'VN', N'GO',  2015, 1,
N'AWARD WINNING*SPORT*SCHOOL LIFE*DRAMA*SLICE OF LIFE',
N'Aoi Ashito is a third year middle school student from Ehime. Behind his raw game hides his immense talent but Ashito suffers a huge setback because of his overly straightforward personality. One day the youth team manager of J1 club Tokyo City Esperion, Fukuda Tetsuya, appears in front of him. Fukuda sees his limitless potential and invites him to take part in his team''s tryouts in Tokyo. The story of the boy who will revolutionize football in Japan rapidly begins to unfold.'
),

(N'M_JP_BlakClov', N'Black Clover', N'BlackClover', N'\Black_Clover', N'AU_JP_TabaYuki', N'VN', N'GO',  2015, 1,
N'SHOUNEN*ACTION*COMEDY*FANTASY*DRAMA*MYSTERY',
N'Asta and Yuno were abandoned together at the same church, and have been inseparable since. As children, they promised that they would compete against each other to see who would become the next Emperor Magus. However, as they grew up, some differences between them became plain. Yuno was a genius with magic, with amazing power and control, while Asta could not use magic at all, and tried to make up for his lack by training physically. When they received their Grimoires at age 15, Yuno got a spectacular book with a four-leaf clover (most people receive a three-leaf-clover), while Asta received nothing at all. However, when Yuno was threatened, the truth about Asta''s power was revealed, he received a five-leaf clover Grimoire, a "black clover"! Now the two friends are heading out in the world, both seeking the same goal!'
),

(N'M_JP_BluLock', N'Blue Lock', N'Bluelock', N'\Blue_Lock', N'AU_JP_KaneMune', N'VN', N'GO', 2018, 1,
N'AWARD WINNING*SPORT*SHOUNEN*SCHOOL LIFE*DRAMA*SLICE OF LIFE',
N'Yoichi Isagi lost the opportunity to go to the national high school championships because he passed to his teammate who missed instead of shooting himself. Isagi is one of 300 U-18 strikers chosen by Jinpachi Ego, a man who was hired by the Japan Football Association after the 2018 FIFA World Cup, to guide Japan to winning the World Cup by destroying Japanese football. Ego''s plan is to isolate the 300 strikers into a prison-like institution called "Blue Lock", in order to create the world''s biggest "egotist"/striker, which has been lacking in Japanese football

In 2021, the series won the 45th Kodansha Manga Awards in the shounen category.'
),

(N'M_JP_CSM', N'Chainsaw Man', N'Chainsaw Man', N'\Chainsaw_Man', N'AU_JP_FujiTatsu', N'VN', N'GO',  2018, 1,
N'AWARD WINNING*GORE*ACTION*SHOUNEN*COMEDY*HORROR*SUPERNATURAL',
N'Broke young man + chainsaw dog demon = Chainsaw Man!

The name says it all! Denji''s life of poverty is changed forever when he merges with his pet chainsaw dog, Pochita! Now he''s living in the big city and an official Devil Hunter. But he''s got a lot to learn about his new job and chainsaw powers!'
),

(N'M_EN_Cyborg', N'Cyborg', N'Cyborg (DC Comics)', N'\Cyborg_DC', N'AU_EN_MarvWolf', N'VN', N'GO',  2015, 1,
N'SUPERHERO*ACTION*SCI-FY*DRAMA*TRAGEDY',
N'Tells the solo side stories of the DC Teen Titans hero Cyborg (Victor "Vic" Stone)'
),

(N'M_CN_DouLuo', N'DouLuo DaLu', N'Doula Continent*Soul Land', N'\DouLuo_DaLu', N'AU_CN_SanShao', N'VN', N'GO',  2011, 1,
N'MANHUA*ACTION*ROMANCE*FANTASY*DRAMA*MARTIAL ARTS',
N'Tang San was a talented apprentice to the great Tang Sect. Due to mastering the forbidden Tang arts, he was pressured to jump off a cliff and died. However, he was reborn into another world filled with Essence Spirits. At the age of six, every person will have their essence spirit awoken. Spirits can take many forms: weapons, plants, and animals; They can help people with their daily lives. Outstanding spirits can be trained to engage in combat. A spirit master is the soul and heart of the Combat Continent! When Tang San turns six, a huge surprise awaits him. His peaceful life in this new world will change completely'
),

(N'M_CN_Doupo', N'Doupo Cangqiong', N'Fights Breaking Through The Heavens*Battle Through the Sky', N'\Doupo_Cangqiong', N'AU_CN_TuDou', N'VN', N'GO',  2012, 1,
N'MANHUA*ACTION*HAREM*ROMANCE*COMEDY*FANTASY*DRAMA*MARTIAL ARTS',
N'In a land where there is no magic, a land where the strong make the rules and weak have to obey, a land filled with alluring treasures and beauty, yet also filled with unforeseen danger. Xiao Yan, who has shown talents none had seen in decades, suddenly lost everything three years ago - his powers, his reputation, and his promise to his mother. What sorcery has caused him to lose all of his powers? And why has his fiancée suddenly shown up?'
),

(N'M_JP_DragBall', N'Dragon Ball', N'DragonBall', N'\Dragon_Ball', N'AU_JP_ToriAkira', N'VN', N'COMP',  1984, 1,
N'SHOUNEN*AWARD WINNING*ACTION*COMEDY*FANTASY*SCI-FY*SPORT*MARTIAL ARTS*DRAMA*SLICE OF LIFE*SUGGESTIVE*GORE',
N'Dragon Ball follows the adventures of Goku from his childhood through adulthood as he trains in martial arts and explores the world in search of the seven mystical orbs known as the Dragon Balls, which can summon a wish-granting dragon when gathered. Along his journey, Goku makes several friends and battles a wide variety of villains, many of whom also seek the Dragon Balls for their own desires. Along the way becoming the strongest warrior in the universe'
),

(N'M_KR_GoHS', N'The God of High School', N'God of High school', N'\God_of_Highschool', N'AU_KR_YongJe', N'VN', N'COMP', 2011, 1,
N'MANHWA*ACTION*COMEDY*SUPERNATURAL*FANTASY*DRAMA*MARTIAL ARTS',
N'The "God of High School" is a fierce competition held between Korean high school students to determine the best fighter among them. All styles of martial arts and weapons are allowed. The ultimate prize? The winner''s deepest desire will be granted, no matter the cost.

Jin Mo-Ri has been training in taekwondo under his grandfather from a young age. Obsessed with fighting, he enters the tournament to find and challenge stronger opponents. Along the way, he meets Han Dae-Wi, an expert in karate who is determined to become the champion to help his friend who is between life and death, and Yu Mi-Ra, a skilled swordswoman who wants to continue her family''s legacy.

Although this tournament seems simple, what more lies in store for Jin Mo-Ri and his friends? And will they be prepared to face what may come to pass?'
),

(N'M_JP_MHA', N'My Hero Academia', N'Boku no Hero Academia', N'\My_Hero_Academia', N'AU_JP_HoriKou', N'VN', N'GO', 2014, 1,
N'SHOUNEN*ACTION*COMEDY*SCI-FY*SUPERHERO*FANTASY*DRAMA*MARTIAL ARTS*SLICE OF LIFE*SCHOOL LIFE*SUPERNATURAL',
N'One day, a four-year-old boy came to a sudden realization: the world is not fair. Eighty percent of the world''s population wield special abilities, known as "quirks," which have given many the power to make their childhood dreams of becoming a superhero a reality. Unfortunately, Izuku Midoriya was one of the few born without a quirk, suffering from discrimination because of it. Yet, he refuses to give up on his dream of becoming a hero; determined to do the impossible, Izuku sets his sights on the elite hero training academy, UA High.

However, everything changes after a chance meeting with the number one hero and Izuku''s idol, All Might. Discovering that his dream is not a dead end, the powerless boy undergoes special training, working harder than ever before. Eventually, this leads to him inheriting All Might''s power, and with his newfound abilities, gets into his school of choice, beginning his grueling journey to become the successor of the best hero on the planet.'
),

(N'M_JP_DemonSlay', N'Kimetsu no Yaiba', N'Demon Slayer', N'\Demon_Slayer', N'AU_JP_GotoKoyo', N'VN', N'COMP',  2016, 1,
N'SHOUNEN*AWARD WINNING*ACTION*COMEDY*MARTIAL ARTS*DRAMA*SUPERNATURAL*TRAGEDY',
N'Since ancient times, rumors have abounded of man-eating demons lurking in the woods. Because of this, the local townsfolk never venture outside at night. Legend has it that a demon slayer also roams the night, hunting down these bloodthirsty demons.
Ever since the death of his father, Tanjirou has taken it upon himself to support his mother and five siblings. Although their lives may be hardened by tragedy, they''ve found happiness. But that ephemeral warmth is shattered one day when Tanjirou finds his family slaughtered and the lone survivor, his sister Nezuko, turned into a demon. Adding to this sorrow, a demon hunter named Tomioka Giyuu arrived and was about to finish Nezuko off, but to his surprise she and Tanjiro started to protect each other. Seeing this oddity and Tanjiro''s promising fighting skills, Giyuu decides to send them to his old mentor to be trained.
So begins Tanjiro''s life as a demon hunter, bound on a quest to cure his sister and find the one who murdered his entire family.'
),

(N'M_JP_KuroBask', N'Kuroko''s Basketball', N'Kuroko no Basket', N'\Kuroko_Basketball', N'AU_JP_FujiTada', N'VN', N'COMP', 2008, 1,
N'SHOUNEN*COMEDY*SPORT*SLICE OF LIFE',
N'Teikou Middle School is famous for its highly renowned basketball team, which produced the famed "Generation of Miracles": a team of five prodigies, each with their own unique abilities, considered to be undefeatable by the time they became third years. However, blinded by pride, they split up, entering different high schools upon graduation.

Taiga Kagami, having just returned from America, joins the basketball team at Seirin High School in search of strong team members. There, he finds Tetsuya Kuroko, a seemingly unimpressive player, only for Kagami to find out that Kuroko was the "Phantom Sixth Member" of the Generation of Miracles: an invisible player who used his impeccable passing skills to support the team from the shadows. Together, they resolve to defeat the Generation of Miracles and make the Seirin basketball team the best in Japan'
),

(N'M_EN_LuckyLuke', N'Lucky Luke', N'Lucky Luke issues collection', N'\Lucky_Luke', N'AU_EN_Morris', N'VN', N'COMP', 1946, 1,
N'ACTION*COMEDY',
N'The series takes place in the American Old West of the United States. It stars the titular Lucky Luke, a street-smart gunslinger known as the "man who shoots faster than his shadow", and his intelligent horse Jolly Jumper. Lucky Luke is pitted against various villains, either fictional or inspired by American history or folklore'
),

(N'M_JP_Naruto', N'Naruto', N'Naruto', N'\Naruto', N'AU_JP_KishiMasa', N'VN', N'COMP', 1999, 1,
N'AWARD WINNING*SUGGESTIVE*SHOUNEN*ACTION*COMEDY*FANTASY*DRAMA*MARTIAL ARTS',
N'Before Naruto''s birth, a great demon fox had attacked the Hidden Leaf Village. The 4th Hokage from the leaf village sealed the demon inside the newly born Naruto, causing him to unknowingly grow up detested by his fellow villagers. Despite his lack of talent in many areas of ninjutsu, Naruto strives for only one goal: to gain the title of Hokage, the strongest ninja in his village. Desiring the respect he never received, Naruto works toward his dream with fellow friends Sasuke and Sakura and mentor Kakashi as they go through many trials and battles that come with being a ninja.'
),

(N'M_CN_EnternWill', N'An Eternal Will', N'Renegade Immortal*Yīniàn yǒnghéng', N'\Eternal_Will', N'AU_CN_Ergen', N'VN', N'GO', 2019, 1,
N'MANHUA*ACTION*FANTASY*ROMANCE*HAREM*SUPERNATURAL*MARTIAL ARTS',
N'After three years of trying, Bai Xiaochun sets off to start his journey to immortality. As a disciple in the Stove Room, a single grain of rice helps him towards his quest of eternal life. With his determination to stave off death, will he be able to attain strength and live long?'
),

(N'M_JP_OnePiece', N'One Piece', N'OnePiece', N'\One_Piece', N'AU_JP_OdaEiichi', N'VN', N'GO', 1997, 1,
N'SHOUNEN*AWARD WINNING*GORE*COMEDY*ACTION*FANTASY*DRAMA*MYSTERY*SUPERNATURAL*TRAGEDY',
N'Gol D. Roger, a man referred to as the "Pirate King," is set to be executed by the World Government. But just before his demise, he confirms the existence of a great treasure, One Piece, located somewhere within the vast ocean known as the Grand Line. Announcing that One Piece can be claimed by anyone worthy enough to reach it, the Pirate King is executed and the Great Age of Pirates begins.

Twenty-two years later, a young man by the name of Monkey D. Luffy is ready to embark on his own adventure, searching for One Piece and striving to become the new Pirate King. Armed with just a straw hat, a small boat, and an elastic body, he sets out on a fantastic journey to gather his own crew and a worthy ship that will take them across the Grand Line to claim the greatest status on the high seas.'
),

(N'M_JP_OPM', N'One Punch-Man', N'One Punch Man', N'\One_Punch_Man', N'AU_JP_MuraYuusuke', N'VN', N'GO', 2012, 1,
N'SHOUNEN*SUGGESTIVE*GORE*ACTION*SCI-FI*SUPERHERO*MARTIAL ARTS*COMEDY*FANTASY*SLICE OF LIFE',
N'After rigorously training for three years, the ordinary Saitama has gained immense strength which allows him to take out anyone and anything with just one punch. He decides to put his new skill to good use by becoming a hero. However, he quickly becomes bored with easily defeating monsters, and wants someone to give him a challenge to bring back the spark of being a hero.

Upon bearing witness to Saitama''s amazing power, Genos, a cyborg, is determined to become Saitama''s apprentice. During this time, Saitama realizes he is neither getting the recognition that he deserves nor known by the people due to him not being a part of the Hero Association. Wanting to boost his reputation, Saitama decides to have Genos register with him, in exchange for taking him in as a pupil. Together, the two begin working their way up toward becoming true heroes, hoping to find strong enemies and earn respect in the process.'
),

(N'M_EN_PlanetHulk', N'Planet Hulk', N'Hulk', N'\Planet_Hulk', N'AU_EN_GregPak', N'VN', N'GO', 2006, 1,
N'GORE*SUPERHERO*ACTION*FANTASY*SCI-FY*SUGGESTIVE',
N'"Planet Hulk" is a Marvel Comics storyline that ran primarily through issues of The Incredible Hulk starting in 2006. Written by Greg Pak, it dealt with the Marvel heroes''s decision to send the Hulk away, his acclimation to and conquest of the planet where he landed, and his efforts to return to Earth to take his revenge'
),

(N'M_EN_WondrWomen', N'Wonder Women', N'Wonder Women', N'\Wonder_Women', N'AU_EN_CharlesMoulten', N'VN', N'HIA', 1941, 1,
N'GORE*SUPERHERO*ACTION*FANTASY*DRAMA*TRAGEDY*SUGGESTIVE',
N'Following the storyline of Wonder Women, a founding member of the Justice League from the DC comics universe'
),

(N'M_EN_TinTinBlckGold', N'Land of Black Gold', N'Tin tin in the Land of Black Gold', N'\TinTin_Black_Gold', N'AU_EN_Herge', N'VN', N'CANC', 1939, 1,
N'ACTION*COMEDY*DRAMA*MYSTERY',
N'Land of Black Gold is the fifteenth volume of The Adventures of Tintin, the comics series by Belgian cartoonist Hergé. Set on the eve of a European war, the plot revolves around the attempts of young Belgian reporter Tintin to uncover a militant group responsible for sabotaging oil supplies in the Middle East.'
),

(N'M_JP_Anohana_Nov', N'Anohana: The Flower We Saw That Day', N'Anohana', N'\Anohana_Nov', N'AU_JP_OkadaMari', N'EN', N'COMP', 2011, 1,
N'NOVEL*ROMANCE*DRAMA*SLICE OF LIFE*FANTASY',
N'Jinta Yadomi and his group of childhood friends have become estranged after a tragic accident split them apart. Now in their high school years, a sudden surprise forces each of them to confront their guilt over what happened that day and come to terms with the ghosts of their past.'
),

(N'M_JP_FiveCenti_Nov', N'5 Centimeters per Second', N'Byosoku Go Senchimetoru', N'\Five_Centimeter_Nov', N'AU_JP_MakoShinkai', N'EN', N'COMP', 2007, 1,
N'NOVEL*AWARD WINNING*ROMANCE*DRAMA*SLICE OF LIFE*SEINEN',
N'The first novel written by Makoto Shinkai. Consisting of three segments, the story is set in Japan, beginning in the early 1990s up until the present day (2008), with each act centered on a boy named Takaki Tōno , each following a period in his life and his relationships with the girls around him.'
),

(N'M_JP_GoblinSlay_Nov', N'Goblin Slayer', N'GoblinSlayer', N'\Goblin_Slayer_Nov', N'AU_JP_KumoKagyu', N'EN', N'GO', 2016, 1,
N'NOVEL*FANTASY*SHOUNEN*GORE*ACTION*SUGGESTIVE*ADVENTURE*HAREM*HORROR',
N'In a world of fantasy, adventurers come from far and wide to join the Guild. They complete contracts to earn gold and glory. An inexperienced priestess joins her first adventuring party, but comes into danger after her first contract involving goblins goes wrong. As the rest of her party is either wiped out or taken out of commission, she is saved by a man known as Goblin Slayer, an adventurer whose only purpose is the eradication of goblins with extreme prejudice.'
),

(N'M_JP_Higehiro_Nov', N'After Being Rejected, I Shaved and Took in a High School Runaway', N'Higehiro', N'\Higehiro_Nov', N'AU_JP_Shimesaba', N'EN', N'GO', 2017, 1,
N'NOVEL*SEINEN*SUGGESTIVE*HAREM*ROMANCE*DRAMA',
N'Young handsome salaryman Yoshida had finally gathered up the courage to confess his feelings for his employer and longtime crush Airi Gotou. Sadly though, he ended up rejected and goes out drinking with his co-worker/best friend Hashimoto to relieve himself of his sorrows. While heading back home in a drunken state, he meets Sayu Ogiwara, a teenage high school girl who asks to spend the night with him. He lets her in out of pity and because he is too exhausted to argue, saying to himself that he will chase her out tomorrow. The next day now sobered up, Yoshida asks Sayu how she ended up at his apartment: she reveals that she had run away from her family and home in Hokkaido and has been prostituting herself to random men in exchange for a place to stay. Now knowing her backstory, Yoshida feeling bad for her finds himself unable to kick her out of his house and their time of living together begins.'
)

INSERT INTO ScanTeam(ScanTeamId, TeamName, TeamSocials, LanguageId) VALUES
(N'SC_VN_SportVn', N'SportVn Team', N'sportVnTeam32@gmail.com', N'VN'),
(N'SC_VN_Mega', N'Mega Team', N'VNSHRING.info', N'VN'),
(N'SC_VN_Eishun', N'Eishun Team', N'https://discord.gg/ZVpZKa2*https://www.facebook.com/EiShunTeam', N'VN'),
(N'SC_VN_Seiya', N'Seiya Team', N'SeiyaTranslate@gmail.com', N'VN'),
(N'SC_VN_DCfanclub', N'DC comics fanclub Vietnam', N'https://www.facebook.com/DCFanclubVN', N'VN'),
(N'SC_VN_Huyen', N'HuyenHuyen.com', N'https://www.facebook.com/vodanhlaanh.noi.', N'VN'),
(N'SC_VN_MH52Tian', N'MH.52Tian.net', N'https://MH.52Tian.net', N'VN'),
(N'SC_VN_Truyenhay24', N'Truyenhay24h.com', N'https://Truyenhay24h.com', N'VN'),
(N'SC_VN_Hamtruyen', N'Hamtruyen.com', N'https://Hamtruyen.com', N'VN'),
(N'SC_VN_Manhuavn', N'manhuavn.com', N'https://manhuavn.com', N'VN'),
(N'SC_VN_FallenAngels', N'Fallen Angels', N'https://www.facebook.com/FallenAngelsMATG', N'VN'),
(N'SC_VN_Vnsharing', N'naruto.vnsharing.net', N'https://naruto.vnsharing.net', N'VN'),
(N'SC_VN_Vnzoom', N'VN Zoom team', N'VN-Zoom.com', N'VN'),
(N'SC_EN_mp4directs', N'mp4directs.com', N'mp4directs.com', N'EN')

INSERT INTO Chapter(MangaId, ChapterOrder, PageNum, ChapterPath, ChapterTitle, ChapterTypeId, ScanTeamId, UploadDate, IsPublished) VALUES
(N'M_JP_AoAshi', 1, 62, N'\AAchapter1', N'First Touch', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-04' AS DateTime), 1),
(N'M_JP_AoAshi', 2, 41, N'\AAchapter2', N'Tokyo City Esperion', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-04' AS DateTime), 1),
(N'M_JP_AoAshi', 3, 18, N'\AAchapter3', N'Essential Light', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-04' AS DateTime), 1),
(N'M_JP_AoAshi', 4, 19, N'\AAchapter4', N'Thinking Power', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-04' AS DateTime), 1),
(N'M_JP_AoAshi', 5, 18, N'\AAchapter5', N'Flash', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-04' AS DateTime), 1),
(N'M_JP_AoAshi', 6, 18, N'\AAchapter6', N'Thinking Reed', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-14' AS DateTime), 1),
(N'M_JP_AoAshi', 7, 18, N'\AAchapter7', N'To Meet', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-14' AS DateTime), 1),
(N'M_JP_AoAshi', 8, 22, N'\AAchapter8', N'Challenge', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-14' AS DateTime), 1),
(N'M_JP_AoAshi', 9, 20, N'\AAchapter9', N'Beginning of The Final Exam', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-14' AS DateTime), 1),
(N'M_JP_AoAshi', 10, 18, N'\AAchapter10', N'Characteristic', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-23' AS DateTime), 1),
(N'M_JP_AoAshi', 11, 18, N'\AAchapter11', N'(Numerical) Inferiority', N'NORM', N'SC_VN_SportVn', CAST(N'2022-08-28' AS DateTime), 1),

(N'M_JP_BlakClov', 1, 51, N'\BCchapter1', N'The Boy''s Vow', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 2, 26, N'\BCchapter2', N'Magic Knights Entrance Exam', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 3, 23, N'\BCchapter3', N'The Road to the Wizard King', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 4, 20, N'\BCchapter4', N'The Black Bulls', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 5, 20, N'\BCchapter5', N'The Other New Member', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 6, 21, N'\BCchapter6', N'Go! Go! First Mission', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 7, 18, N'\BCchapter7', N'Brutes', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 8, 20, N'\BCchapter8', N'Those Who Protect', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 9, 20, N'\BCchapter9', N'The Boy''s Vow 2', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 10, 20, N'\BCchapter10', N'What Happened One Day in the Castle Town', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 11, 20, N'\BCchapter11', N'Dungeon', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 12, 20, N'\BCchapter12', N'Reunion', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 13, 19, N'\BCchapter13', N'The Diamond Mage', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 14, 19, N'\BCchapter14', N'Friends', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),
(N'M_JP_BlakClov', 15, 20, N'\BCchapter15', N'Three People', N'NORM', N'SC_VN_Mega', CAST(N'2022-09-17' AS DateTime), 1),

(N'M_JP_BluLock', 1, 77, N'\BLchapter1', N'Dream', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-03' AS DateTime), 1),
(N'M_JP_BluLock', 2, 74, N'\BLchapter2', N'Moving In', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-03' AS DateTime), 1),
(N'M_JP_BluLock', 3, 26, N'\BLchapter3', N'Monster', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-03' AS DateTime), 1),
(N'M_JP_BluLock', 4, 21, N'\BLchapter4', N'Right Now', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-03' AS DateTime), 1),
(N'M_JP_BluLock', 5, 21, N'\BLchapter5', N'The "Zero" of Soccer', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 6, 22, N'\BLchapter6', N'1 = Individual', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 7, 21, N'\BLchapter7', N'We''ll Meet in Front of the Goal', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 8, 21, N'\BLchapter8', N'Message', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 9, 22, N'\BLchapter9', N'Superhero', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 10, 21, N'\BLchapter10', N'Operation: Me, Next 9', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 11, 21, N'\BLchapter11', N'Premonition & Intuition', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 12, 21, N'\BLchapter12', N'Signal', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 13, 23, N'\BLchapter13', N'The One to Be Reborn', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 14, 22, N'\BLchapter14', N'Resolve', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_BluLock', 15, 21, N'\BLchapter15', N'Spiral', N'NORM', N'SC_VN_Eishun', CAST(N'2022-10-12' AS DateTime), 1),

(N'M_JP_CSM', 1, 57, N'\CMchapter1', N'Dog & Chainsaw', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-03' AS DateTime), 1),
(N'M_JP_CSM', 2, 26, N'\CMchapter2', N'The Place Where Pochita Is', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-03' AS DateTime), 1),
(N'M_JP_CSM', 3, 24, N'\CMchapter3', N'Arrival in Tokyo', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-03' AS DateTime), 1),
(N'M_JP_CSM', 4, 21, N'\CMchapter4', N'Power', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-03' AS DateTime), 1),
(N'M_JP_CSM', 5, 20, N'\CMchapter5', N'A Way to Touch Some Boobs', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-06' AS DateTime), 1),
(N'M_JP_CSM', 6, 18, N'\CMchapter6', N'Service', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-06' AS DateTime), 1),
(N'M_JP_CSM', 7, 19, N'\CMchapter7', N'Meowy''s Whereabouts', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-06' AS DateTime), 1),
(N'M_JP_CSM', 8, 18, N'\CMchapter8', N'Chainsaw vs. Bat', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-06' AS DateTime), 1),
(N'M_JP_CSM', 9, 19, N'\CMchapter9', N'Rescue', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-09' AS DateTime), 1),
(N'M_JP_CSM', 10, 20, N'\CMchapter10', N'Kon', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-09' AS DateTime), 1),
(N'M_JP_CSM', 11, 20, N'\CMchapter11', N'Compromise', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-09' AS DateTime), 1),
(N'M_JP_CSM', 12, 19, N'\CMchapter12', N'Squeeze', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-09' AS DateTime), 1),
(N'M_JP_CSM', 13, 20, N'\CMchapter13', N'Gun Devil', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-09' AS DateTime), 1),
(N'M_JP_CSM', 14, 20, N'\CMchapter14', N'French Kiss', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-11' AS DateTime), 1),
(N'M_JP_CSM', 15, 23, N'\CMchapter15', N'Endless 8th Floor', N'NORM', N'SC_VN_Seiya', CAST(N'2022-11-16' AS DateTime), 1),

(N'M_EN_Cyborg', 1, 22, N'\Cchapter1', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2022-12-02' AS DateTime), 1),
(N'M_EN_Cyborg', 2, 21, N'\Cchapter2', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2022-12-02' AS DateTime), 1),
(N'M_EN_Cyborg', 3, 20, N'\Cchapter3', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2022-12-02' AS DateTime), 1),

(N'M_JP_DemonSlay', 1, 54, N'\KNYchapter1', N'Cruelty', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 2, 27, N'\KNYchapter2', N'The Stranger', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 3, 25, N'\KNYchapter3', N'To Return By Dawn Without Fail', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 4, 21, N'\KNYchapter4', N'Tanjiro''s Journal, Part 1', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 5, 21, N'\KNYchapter5', N'Tanjiro''s Journal, Part 2', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 6, 21, N'\KNYchapter6', N'A Mountain of Hands', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 7, 23, N'\KNYchapter7', N'Spirits of the Deceased', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-02' AS DateTime), 1),
(N'M_JP_DemonSlay', 8, 23, N'\KNYchapter8', N'Big Brother', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-06' AS DateTime), 1),
(N'M_JP_DemonSlay', 9, 21, N'\KNYchapter9', N'Welcome Back', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-07' AS DateTime), 1),
(N'M_JP_DemonSlay', 10, 21, N'\KNYchapter10', N'Kidnapper''s Bog', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-10' AS DateTime), 1),
(N'M_JP_DemonSlay', 11, 21, N'\KNYchapter11', N'Suggestion', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-11' AS DateTime), 1),
(N'M_JP_DemonSlay', 12, 21, N'\KNYchapter12', N'I Can''t Tell You', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-13' AS DateTime), 1),
(N'M_JP_DemonSlay', 13, 20, N'\KNYchapter13', N'It Was You', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-15' AS DateTime), 1),
(N'M_JP_DemonSlay', 14, 21, N'\KNYchapter14', N'Kibutsuji''s Wrath / The Smell of Enchanting Blood', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-17' AS DateTime), 1),
(N'M_JP_DemonSlay', 15, 21, N'\KNYchapter15', N'The Doctor''s Opinion', N'NORM', N'SC_VN_Huyen', CAST(N'2022-10-17' AS DateTime), 1),

(N'M_CN_DouLuo', 1, 25, N'\DLDLchapter1', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-12' AS DateTime), 1),
(N'M_CN_DouLuo', 2, 24, N'\DLDLchapter2', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-12' AS DateTime), 1),
(N'M_CN_DouLuo', 3, 23, N'\DLDLchapter3', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-15' AS DateTime), 1),
(N'M_CN_DouLuo', 4, 24, N'\DLDLchapter4', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-16' AS DateTime), 1),
(N'M_CN_DouLuo', 5, 22, N'\DLDLchapter5', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-18' AS DateTime), 1),
(N'M_CN_DouLuo', 6, 23, N'\DLDLchapter6', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-22' AS DateTime), 1),
(N'M_CN_DouLuo', 7, 25, N'\DLDLchapter7', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-23' AS DateTime), 1),
(N'M_CN_DouLuo', 8, 25, N'\DLDLchapter8', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-23' AS DateTime), 1),
(N'M_CN_DouLuo', 9, 32, N'\DLDLchapter9', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-23' AS DateTime), 1),
(N'M_CN_DouLuo', 10, 28, N'\DLDLchapter10', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-28' AS DateTime), 1),
(N'M_CN_DouLuo', 11, 24, N'\DLDLchapter11', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-29' AS DateTime), 1),
(N'M_CN_DouLuo', 12, 23, N'\DLDLchapter12', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-07-02' AS DateTime), 1),
(N'M_CN_DouLuo', 13, 32, N'\DLDLchapter13', N'', N'NORM', N'SC_VN_MH52Tian', CAST(N'2022-06-03' AS DateTime), 1),

(N'M_CN_Doupo', 1, 31, N'\DPTKchapter1', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-12' AS DateTime), 1),
(N'M_CN_Doupo', 2, 25, N'\DPTKchapter2', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-13' AS DateTime), 1),
(N'M_CN_Doupo', 3, 24, N'\DPTKchapter3', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-13' AS DateTime), 1),
(N'M_CN_Doupo', 4, 24, N'\DPTKchapter4', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-13' AS DateTime), 1),
(N'M_CN_Doupo', 5, 30, N'\DPTKchapter5', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-16' AS DateTime), 1),
(N'M_CN_Doupo', 6, 24, N'\DPTKchapter6', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-17' AS DateTime), 1),
(N'M_CN_Doupo', 7, 24, N'\DPTKchapter7', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-17' AS DateTime), 1),
(N'M_CN_Doupo', 8, 26, N'\DPTKchapter8', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-19' AS DateTime), 1),
(N'M_CN_Doupo', 9, 23, N'\DPTKchapter9', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-21' AS DateTime), 1),
(N'M_CN_Doupo', 10, 24, N'\DPTKchapter10', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-23' AS DateTime), 1),
(N'M_CN_Doupo', 11, 24, N'\DPTKchapter11', N'', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2022-12-23' AS DateTime), 1),

(N'M_JP_DragBall', 1, 37, N'\DBchapter1', N'Bloomers and the Monkey King', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 2, 14, N'\DBchapter2', N'No Balls!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 3, 15, N'\DBchapter3', N'Sea Monkeys', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 4, 15, N'\DBchapter4', N'They Call Him… the Turtle Hermit!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 5, 15, N'\DBchapter5', N'Oo! Oo! Oolong!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 6, 14, N'\DBchapter6', N'So Long, Oolong!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 7, 15, N'\DBchapter7', N'Yamcha and Pu''ar', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 8, 15, N'\DBchapter8', N'One, Two, Yamcha-cha!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 9, 15, N'\DBchapter9', N'Dragon Balls in Danger!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 10, 15, N'\DBchapter10', N'Onward to Fry-Pan', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 11, 15, N'\DBchapter11', N'...And Into the Fire!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 12, 15, N'\DBchapter12', N'In Search of Kame Sen''nin', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 13, 12, N'\DBchapter13', N'Fanning the Flame', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 14, 12, N'\DBchapter14', N'Kamehameha!!', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),
(N'M_JP_DragBall', 15, 15, N'\DBchapter15', N'At Sixes and Sevens', N'NORM', N'SC_VN_Seiya', CAST(N'2021-04-05' AS DateTime), 1),

(N'M_CN_EnternWill', 1, 21, N'\NNVHchapter1', N'', N'NORM', N'SC_VN_Hamtruyen', CAST(N'2021-02-12' AS DateTime), 1),
(N'M_CN_EnternWill', 2, 24, N'\NNVHchapter2', N'', N'NORM', N'SC_VN_Hamtruyen', CAST(N'2021-02-12' AS DateTime), 1),
(N'M_CN_EnternWill', 3, 52, N'\NNVHchapter3', N'', N'NORM', N'SC_VN_Hamtruyen', CAST(N'2021-02-12' AS DateTime), 1),
(N'M_CN_EnternWill', 4, 48, N'\NNVHchapter4', N'', N'NORM', N'SC_VN_Hamtruyen', CAST(N'2021-02-12' AS DateTime), 1),
(N'M_CN_EnternWill', 5, 51, N'\NNVHchapter5', N'', N'NORM', N'SC_VN_Hamtruyen', CAST(N'2021-02-12' AS DateTime), 1),

(N'M_KR_GoHS', 1, 53, N'\GOHchapter1', N'My Name is Jin Mori', N'NORM', N'SC_VN_Manhuavn', CAST(N'2022-01-23' AS DateTime), 1),
(N'M_KR_GoHS', 2, 53, N'\GOHchapter2', N'My Name is Han Daewi', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-23' AS DateTime), 1),
(N'M_KR_GoHS', 3, 41, N'\GOHchapter3', N'My Name is Yoo Mira', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-25' AS DateTime), 1),
(N'M_KR_GoHS', 4, 41, N'\GOHchapter4', N'The Meeting', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-25' AS DateTime), 1),
(N'M_KR_GoHS', 5, 28, N'\GOHchapter5', N'The Matches Begin', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-25' AS DateTime), 1),
(N'M_KR_GoHS', 6, 36, N'\GOHchapter6', N'', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-25' AS DateTime), 1),
(N'M_KR_GoHS', 7, 34, N'\GOHchapter7', N'', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-25' AS DateTime), 1),
(N'M_KR_GoHS', 8, 29, N'\GOHchapter8', N'', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-01-29' AS DateTime), 1),
(N'M_KR_GoHS', 9, 36, N'\GOHchapter9', N'', N'NORM', N'SC_VN_Manhuavn', CAST(N'2021-02-02' AS DateTime), 1),

(N'M_JP_KuroBask', 1, 58, N'\KNBchapter1', N'I''m Kuroko', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-12' AS DateTime), 1),
(N'M_JP_KuroBask', 2, 26, N'\KNBchapter2', N'Monday Morning at 8:40 on the Roof!', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-13' AS DateTime), 1),
(N'M_JP_KuroBask', 3, 24, N'\KNBchapter3', N'I''m Serious', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-13' AS DateTime), 1),
(N'M_JP_KuroBask', 4, 20, N'\KNBchapter4', N'Not Exactly Decent', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-13' AS DateTime), 1),
(N'M_JP_KuroBask', 5, 21, N'\KNBchapter5', N'More Than a Pretty Face', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-15' AS DateTime), 1),
(N'M_JP_KuroBask', 6, 21, N'\KNBchapter6', N'Not Winning''s Fine by Me', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-16' AS DateTime), 1),
(N'M_JP_KuroBask', 7, 19, N'\KNBchapter7', N'Go for the Counterattack!', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-19' AS DateTime), 1),
(N'M_JP_KuroBask', 8, 18, N'\KNBchapter8', N'Here I Go', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-22' AS DateTime), 1),
(N'M_JP_KuroBask', 9, 21, N'\KNBchapter9', N'I Made a Promise', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-22' AS DateTime), 1),
(N'M_JP_KuroBask', 10, 20, N'\KNBchapter10', N'"Man Plans, the Heavens Laugh"', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-28' AS DateTime), 1),
(N'M_JP_KuroBask', 11, 21, N'\KNBchapter11', N'Your Basketball', N'NORM', N'SC_VN_Manhuavn', CAST(N'2020-7-30' AS DateTime), 1),

(N'M_EN_LuckyLuke', 1, 44, N'\LLchapter1', N'#37 Fingers', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2019-7-12' AS DateTime), 1),
(N'M_EN_LuckyLuke', 2, 45, N'\LLchapter2', N'#26 The bounty hunter', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2019-7-12' AS DateTime), 1),
(N'M_EN_LuckyLuke', 3, 46, N'\LLchapter3', N'#9 The wagon train', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2019-7-12' AS DateTime), 1),
(N'M_EN_LuckyLuke', 4, 45, N'\LLchapter4', N'#58 The Daltons'' stash', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2019-7-12' AS DateTime), 1),

(N'M_JP_MHA', 1, 52, N'\HAchapter1', N'Izuku Midoriya: Origins', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-6-28' AS DateTime), 1),
(N'M_JP_MHA', 2, 26, N'\HAchapter2', N'Roaring Muscles', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-6-28' AS DateTime), 1),
(N'M_JP_MHA', 3, 23, N'\HAchapter3', N'Entrance Exam', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-6-28' AS DateTime), 1),
(N'M_JP_MHA', 4, 20, N'\HAchapter4', N'Starting Line', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-6-30' AS DateTime), 1),
(N'M_JP_MHA', 5, 20, N'\HAchapter5', N'Smashing into Academia', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-02' AS DateTime), 1),
(N'M_JP_MHA', 6, 19, N'\HAchapter6', N'What I Can Do for Now', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-02' AS DateTime), 1),
(N'M_JP_MHA', 7, 19, N'\HAchapter7', N'Costume Change?', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-04' AS DateTime), 1),
(N'M_JP_MHA', 8, 19, N'\HAchapter8', N'Rage, You Damned Nerd', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-05' AS DateTime), 1),
(N'M_JP_MHA', 9, 23, N'\HAchapter9', N'Deku vs. Kacchan', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-08' AS DateTime), 1),
(N'M_JP_MHA', 10, 22, N'\HAchapter10', N'Breaking Bakugo', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-08' AS DateTime), 1),
(N'M_JP_MHA', 11, 20, N'\HAchapter11', N'Bakugo''s Starting Line', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-12' AS DateTime), 1),
(N'M_JP_MHA', 12, 22, N'\HAchapter12', N'Yeah, Just Do Your Best, Ida!', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-13' AS DateTime), 1),
(N'M_JP_MHA', 13, 19, N'\HAchapter13', N'Rescue Training', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-16' AS DateTime), 1),
(N'M_JP_MHA', 14, 23, N'\HAchapter14', N'Encounter with the Unknown', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-20' AS DateTime), 1),
(N'M_JP_MHA', 15, 19, N'\HAchapter15', N'Vs.', N'NORM', N'SC_VN_FallenAngels', CAST(N'2021-7-22' AS DateTime), 1),

(N'M_JP_Naruto', 1, 55, N'\Nchapter1', N'Uzumaki Naruto!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-3-22' AS DateTime), 1),
(N'M_JP_Naruto', 2, 23, N'\Nchapter2', N'Konohamaru!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-3-24' AS DateTime), 1),
(N'M_JP_Naruto', 3, 24, N'\Nchapter3', N'Enter Sasuke!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-3-25' AS DateTime), 1),
(N'M_JP_Naruto', 4, 20, N'\Nchapter4', N'Hatake Kakashi!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-3-27' AS DateTime), 1),
(N'M_JP_Naruto', 5, 20, N'\Nchapter5', N'Pride Goeth Before a Fall!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-3-28' AS DateTime), 1),
(N'M_JP_Naruto', 6, 19, N'\Nchapter6', N'Not Sasuke!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-3-30' AS DateTime), 1),
(N'M_JP_Naruto', 7, 19, N'\Nchapter7', N'Kakashi''s Decision!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-02' AS DateTime), 1),
(N'M_JP_Naruto', 8, 19, N'\Nchapter8', N'You Failed!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-03' AS DateTime), 1),
(N'M_JP_Naruto', 9, 24, N'\Nchapter9', N'The Worst Client', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-07' AS DateTime), 1),
(N'M_JP_Naruto', 10, 20, N'\Nchapter10', N'Target #2', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-08' AS DateTime), 1),
(N'M_JP_Naruto', 11, 20, N'\Nchapter11', N'Going Ashore', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-09' AS DateTime), 1),
(N'M_JP_Naruto', 12, 19, N'\Nchapter12', N'Game Over!!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-11' AS DateTime), 1),
(N'M_JP_Naruto', 13, 20, N'\Nchapter13', N'Ninja!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-13' AS DateTime), 1),
(N'M_JP_Naruto', 14, 20, N'\Nchapter14', N'The Secret Plan...!!!', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-13' AS DateTime), 1),
(N'M_JP_Naruto', 15, 18, N'\Nchapter15', N'Return of the Sharingan', N'NORM', N'SC_VN_Vnsharing', CAST(N'2019-4-16' AS DateTime), 1),

(N'M_JP_OnePiece', 1, 54, N'\OPchapter1', N'Romance Dawn - The Dawn of Adventure', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-5-30' AS DateTime), 1),
(N'M_JP_OnePiece', 2, 23, N'\OPchapter2', N'That Guy, "Straw Hat Luffy"', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-5-31' AS DateTime), 1),
(N'M_JP_OnePiece', 3, 21, N'\OPchapter3', N'Introducing Pirate Hunter Zoro', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-02' AS DateTime), 1),
(N'M_JP_OnePiece', 4, 20, N'\OPchapter4', N'The Great Captain Morgan', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-03' AS DateTime), 1),
(N'M_JP_OnePiece', 5, 20, N'\OPchapter5', N'The King of the Pirates and the Master Swordsman', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-04' AS DateTime), 1),
(N'M_JP_OnePiece', 6, 23, N'\OPchapter6', N'Number One', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-05' AS DateTime), 1),
(N'M_JP_OnePiece', 7, 21, N'\OPchapter7', N'Friends', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-08' AS DateTime), 1),
(N'M_JP_OnePiece', 8, 19, N'\OPchapter8', N'Nami', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-10' AS DateTime), 1),
(N'M_JP_OnePiece', 9, 21, N'\OPchapter9', N'Femme Fatale', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-11' AS DateTime), 1),
(N'M_JP_OnePiece', 10, 23, N'\OPchapter10', N'Incident at the Tavern', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-12' AS DateTime), 1),
(N'M_JP_OnePiece', 11, 19, N'\OPchapter11', N'Flight', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-14' AS DateTime), 1),
(N'M_JP_OnePiece', 12, 20, N'\OPchapter12', N'Dog', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-17' AS DateTime), 1),
(N'M_JP_OnePiece', 13, 19, N'\OPchapter13', N'Treasure', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-18' AS DateTime), 1),
(N'M_JP_OnePiece', 14, 18, N'\OPchapter14', N'Reckless', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-22' AS DateTime), 1),
(N'M_JP_OnePiece', 15, 19, N'\OPchapter15', N'Gong', N'NORM', N'SC_VN_Vnzoom', CAST(N'2018-6-28' AS DateTime), 1),

(N'M_JP_OPM', 1, 21, N'\OMchapter1', N'One Punch', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-04' AS DateTime), 1),
(N'M_JP_OPM', 2, 16, N'\OMchapter2', N'Crab and Job Hunting', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-04' AS DateTime), 1),
(N'M_JP_OPM', 3, 23, N'\OMchapter3', N'Walking Disaster', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-04' AS DateTime), 1),
(N'M_JP_OPM', 4, 21, N'\OMchapter4', N'Subterraneans of Darkness', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-04' AS DateTime), 1),
(N'M_JP_OPM', 5, 21, N'\OMchapter5', N'Itch Explosion', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 6, 26, N'\OMchapter6', N'Saitama', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 7, 18, N'\OMchapter7', N'A Mysterious Attack', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 8, 24, N'\OMchapter8', N'This Guy?', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 9, 25, N'\OMchapter9', N'House of Evolution', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 10, 33, N'\OMchapter10', N'Modern Art', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 11, 23, N'\OMchapter11', N'The Secret to Strength', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-06' AS DateTime), 1),
(N'M_JP_OPM', 12, 26, N'\OMchapter12', N'The Paradisers', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-13' AS DateTime), 1),
(N'M_JP_OPM', 13, 27, N'\OMchapter13', N'Speed', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-13' AS DateTime), 1),
(N'M_JP_OPM', 14, 24, N'\OMchapter14', N'I Don''t Know You', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-13' AS DateTime), 1),
(N'M_JP_OPM', 15, 27, N'\OMchapter15', N'Fun and Work', N'NORM', N'SC_VN_Truyenhay24', CAST(N'2020-01-13' AS DateTime), 1),

(N'M_EN_PlanetHulk', 1, 22, N'\PHchapter1', N'Planet Hulk Exile: Part 1', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-04-15' AS DateTime), 1),
(N'M_EN_PlanetHulk', 1, 25, N'\PHchapter1', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-04-15' AS DateTime), 1),
(N'M_EN_PlanetHulk', 1, 25, N'\PHchapter1', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-04-15' AS DateTime), 1),
(N'M_EN_PlanetHulk', 1, 22, N'\PHchapter1', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-04-15' AS DateTime), 1),

(N'M_EN_TinTinBlckGold', 1, 32, N'\TTDXVDchapter1', N'', N'NORM', N'SC_VN_FallenAngels', CAST(N'2020-8-21' AS DateTime), 1),
(N'M_EN_TinTinBlckGold', 2, 32, N'\TTDXVDchapter2', N'', N'NORM', N'SC_VN_FallenAngels', CAST(N'2020-8-21' AS DateTime), 1),

(N'M_EN_WondrWomen', 1, 26, N'\WWchapter1', N'God draws blood', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-11-02' AS DateTime), 1),
(N'M_EN_WondrWomen', 2, 20, N'\WWchapter2', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-11-02' AS DateTime), 1),
(N'M_EN_WondrWomen', 3, 23, N'\WWchapter3', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-11-02' AS DateTime), 1),
(N'M_EN_WondrWomen', 4, 21, N'\WWchapter4', N'', N'NORM', N'SC_VN_DCfanclub', CAST(N'2020-11-02' AS DateTime), 1),

(N'M_JP_Higehiro_Nov', 1, 282, N'\HGchapter1', N'Volume 1', N'NORM', N'SC_EN_mp4directs', CAST(N'2021-08-02' AS DateTime), 1),

(N'M_JP_GoblinSlay_Nov', 1, 307, N'\GBchapter1', N'Volume 1', N'NORM', N'SC_EN_mp4directs', CAST(N'2022-03-12' AS DateTime), 1),

(N'M_JP_FiveCenti_Nov', 1, 212, N'\FCchapter1', N'Volume 1', N'NORM', N'SC_EN_mp4directs', CAST(N'2022-07-26' AS DateTime), 1),

(N'M_JP_Anohana_Nov', 1, 143, N'\ANchapter1', N'Volume 1', N'NORM', N'SC_EN_mp4directs', CAST(N'2021-12-04' AS DateTime), 1)

INSERT INTO [User](UserName, UserPassword, Bookmarks) VALUES
(N'Mark Dye', N'40bd001563085fc35165329ea1ff5c5ecbdbbeef',
N'M_JP_CSM*M_JP_OPM*M_KR_GoHS'), --123
(N'Dee mega', N'51eac6b471a284d3341d8c0c63d0f1a286262a18',
N'M_JP_Higehiro_Nov*M_JP_Naruto*M_JP_Anohana_Nov'), --456
(N'Xi jinping', N'fc1200c7a7aa52109d762a9f005b149abef01479',
N'M_CN_DouLuo*M_CN_DouPo*M_JP_CSM*M_JP_OPM'), --789
(N'Cing Billing', N'8abcda2dba9a5c5c674e659333828582122c5f56',
N'M_JP_OPM*M_JP_GoblinSlay_Nov*M_JP_FiveCenti_Nov') --987

INSERT INTO Rating(MangaId, UserId, Score) VALUES
(N'M_JP_CSM', 1, 4),
(N'M_JP_CSM', 3, 3),
(N'M_JP_OPM', 3, 4),
(N'M_JP_OPM', 2, 5),
(N'M_JP_OPM', 4, 1),
(N'M_KR_GoHS', 1, 2),
(N'M_KR_GoHS', 3, 2),
(N'M_JP_Higehiro_Nov', 2, 4),
(N'M_JP_Naruto', 2, 3),
(N'M_JP_Naruto', 3, 5),
(N'M_JP_GoblinSlay_Nov', 2, 5),
(N'M_JP_GoblinSlay_Nov', 4, 5),
(N'M_JP_FiveCenti_Nov', 2, 2),
(N'M_JP_Anohana_Nov', 2, 5)

GO
