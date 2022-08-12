-- Create a new database called 'DatabaseName'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'ApplicantsTrackingDB'
)
CREATE DATABASE ApplicantsTrackingDB
GO

USE [ApplicantsTrackingDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GetStatusFromDate]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetStatusFromDate]
(
	@StartDate [datetime],
	@EndDate [datetime]
)
RETURNS INT
AS
BEGIN
	DECLARE @Today [datetime]
	SET @Today = GETDATE()
	IF @Today < @StartDate
	BEGIN
		RETURN 2;
	END
	ELSE
	BEGIN
		IF @Today < @EndDate
		BEGIN
			RETURN 1;
		END
	END
	RETURN 3;
END
GO
/****** Object:  Table [dbo].[ProgramVersion]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramVersion](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StartDate] [nvarchar](30) NOT NULL,
	[EndDate] [nvarchar](30) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ProgramId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ProgramVersion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_ProgramVersion]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Action:  Views    Script Date: 4/9/2021 10:15:32 ******/
CREATE VIEW [dbo].[VW_ProgramVersion]
AS
	SELECT *, [dbo].[GetStatusFromDate](
	CONVERT(datetime2, [StartDate]),
	CONVERT(datetime2, [EndDate])
	) AS [Status]
	FROM [dbo].[ProgramVersion]
GO
/****** Object:  Table [dbo].[Answer]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answer](
	[Id] [uniqueidentifier] NOT NULL,
	[EvaluationId] [uniqueidentifier] NOT NULL,
	[QuestionId] [uniqueidentifier] NOT NULL,
	[OptionId] [uniqueidentifier] NULL,
	[Comment] [nvarchar](255) NULL,
 CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Approval]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Approval](
	[Id] [uniqueidentifier] NOT NULL,
	[SubjectId] [uniqueidentifier] NULL,
	[EvaluationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Checked] [bit] NOT NULL,
 CONSTRAINT [PK_Approval] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Evaluation]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Evaluation](
	[Id] [uniqueidentifier] NOT NULL,
	[ScholarId] [uniqueidentifier] NOT NULL,
	[StageId] [uniqueidentifier] NOT NULL,
	[OverallRating] [int] NULL,
	[GeneralComments] [nvarchar](255) NULL,
	[Goals] [nvarchar](255) NULL,
	[IsRecommended] [bit] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[CurrentVersion] [int] NULL,
 CONSTRAINT [PK_Evaluation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EvaluationSkills]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationSkills](
	[Id] [uniqueidentifier] NOT NULL,
	[EvaluationId] [uniqueidentifier] NOT NULL,
	[SkillId] [uniqueidentifier] NOT NULL,
	[Score] [int] NOT NULL,
 CONSTRAINT [PK_EvaluationSkills] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[Title] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ScholarId] [uniqueidentifier] NOT NULL,
	[SubjectId] [uniqueidentifier] NOT NULL,
	[EventTypeId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventType]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Image]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Image](
	[UserId] [uniqueidentifier] NOT NULL,
	[ProviderImageKey] [nvarchar](256) NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Image_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Option]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Option](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Weight] [int] NOT NULL,
 CONSTRAINT [PK_Option] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[Id] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](256) NOT NULL,
	[LastName] [nvarchar](256) NULL,
	[CI] [nvarchar](256) NULL,
	[PersonalEmail] [nvarchar](256) NULL,
	[Issued] [nvarchar](256) NULL,
	[CurrentCity] [nvarchar](256) NULL,
	[Gender] [nvarchar](256) NULL,
	[PhoneNumber] [nvarchar](256) NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Program]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Program](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramSkills]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramSkills](
	[ProgramsId] [uniqueidentifier] NOT NULL,
	[SkillsId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ProgramSkills] PRIMARY KEY CLUSTERED 
(
	[ProgramsId] ASC,
	[SkillsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[Id] [uniqueidentifier] NOT NULL,
	[SkillId] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Weight] [int] NOT NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionOptions]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionOptions](
	[Id] [uniqueidentifier] NOT NULL,
	[OptionId] [uniqueidentifier] NOT NULL,
	[QuestionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_QuestionOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Scholar]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Scholar](
	[Id] [uniqueidentifier] NOT NULL,
	[PersonId] [uniqueidentifier] NOT NULL,
	[University] [nvarchar](256) NULL,
	[InstitutionalEmail] [nvarchar](256) NULL,
	[Career] [nvarchar](256) NULL,
	[AcademicDegree] [nvarchar](256) NULL,
	[StatusTypeId] [int] NULL,
	[SubjectId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Scholar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScholarPrograms]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScholarPrograms](
	[ScholarId] [uniqueidentifier] NOT NULL,
	[ProgramVersionId] [uniqueidentifier] NOT NULL,
	[EnrollDate] [nvarchar](256) NOT NULL,
	[EndDate] [nvarchar](256) NULL,
	[Description] [nvarchar](256) NULL,
 CONSTRAINT [PK_ScholarPrograms] PRIMARY KEY CLUSTERED 
(
	[ScholarId] ASC,
	[ProgramVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Skill]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Skill](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Skill] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stage]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stage](
	[Id] [uniqueidentifier] NOT NULL,
	[StageNumber] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[StartDate] [nvarchar](30) NOT NULL,
	[EndDate] [nvarchar](30) NOT NULL,
	[ApprovalRequired] [bit] NOT NULL,
	[ProgramVersionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Stage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatusHistory]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusHistory](
	[ScholarId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[OldStatus] [int] NULL,
	[CurrentStatus] [int] NULL,
	[Description] [varchar](100) NULL,
	[CreateAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[SubjectId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_StatusHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatusType]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusType](
	[Id] [int] NOT NULL,
	[Name] [nchar](50) NULL,
 CONSTRAINT [PK_StatusType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grade]    Script Date: 08/05/2022 17:44:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grade](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](10) NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[Value] [int] NOT NULL,
	[GPA] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubjectEvaluation]    Script Date: 25/04/2022 03:17:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectEvaluation](
	[Id] [uniqueidentifier] NOT NULL,
	[ScholarId] [uniqueidentifier] NOT NULL,
	[SubjectId] [uniqueidentifier] NOT NULL,
	[GradeId] [uniqueidentifier] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[EvaluationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SubjectEvaluation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 10/8/2021 10:51:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject](
	[Id] [uniqueidentifier] NOT NULL,
	[SubjectNumber] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[StageId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Subject] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Event] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Event] ADD  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[StatusHistory] ADD  CONSTRAINT [DF_StatusHistory_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Evaluation] FOREIGN KEY([EvaluationId])
REFERENCES [dbo].[Evaluation] ([Id])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Evaluation]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Option] FOREIGN KEY([OptionId])
REFERENCES [dbo].[Option] ([Id])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Option]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Question] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Question] ([Id])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Question]
GO
ALTER TABLE [dbo].[Approval]  WITH CHECK ADD  CONSTRAINT [FK_Approval_Evaluation] FOREIGN KEY([EvaluationId])
REFERENCES [dbo].[Evaluation] ([Id])
GO
ALTER TABLE [dbo].[Approval] CHECK CONSTRAINT [FK_Approval_Evaluation]
GO
ALTER TABLE [dbo].[Evaluation]  WITH CHECK ADD  CONSTRAINT [FK_Evaluation_Scholar] FOREIGN KEY([ScholarId])
REFERENCES [dbo].[Scholar] ([Id])
GO
ALTER TABLE [dbo].[Evaluation] CHECK CONSTRAINT [FK_Evaluation_Scholar]
GO
ALTER TABLE [dbo].[EvaluationSkills]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationSkills_Evaluation] FOREIGN KEY([EvaluationId])
REFERENCES [dbo].[Evaluation] ([Id])
GO
ALTER TABLE [dbo].[EvaluationSkills] CHECK CONSTRAINT [FK_EvaluationSkills_Evaluation]
GO
ALTER TABLE [dbo].[EvaluationSkills]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationSkills_Skill] FOREIGN KEY([SkillId])
REFERENCES [dbo].[Skill] ([Id])
GO
ALTER TABLE [dbo].[EvaluationSkills] CHECK CONSTRAINT [FK_EvaluationSkills_Skill]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventType] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_EventTypeId]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_ScholarId] FOREIGN KEY([ScholarId])
REFERENCES [dbo].[Scholar] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_ScholarId]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_SubjectId] FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subject] ([Id])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_SubjectId]
GO
ALTER TABLE [dbo].[ProgramSkills]  WITH CHECK ADD  CONSTRAINT [FK_ProgramSkills_Program] FOREIGN KEY([ProgramsId])
REFERENCES [dbo].[Program] ([Id])
GO
ALTER TABLE [dbo].[ProgramSkills] CHECK CONSTRAINT [FK_ProgramSkills_Program]
GO
ALTER TABLE [dbo].[ProgramSkills]  WITH CHECK ADD  CONSTRAINT [FK_ProgramSkills_Skill] FOREIGN KEY([SkillsId])
REFERENCES [dbo].[Skill] ([Id])
GO
ALTER TABLE [dbo].[ProgramSkills] CHECK CONSTRAINT [FK_ProgramSkills_Skill]
GO
ALTER TABLE [dbo].[ProgramVersion]  WITH CHECK ADD  CONSTRAINT [FK_ProgramVersion_ProgramId] FOREIGN KEY([ProgramId])
REFERENCES [dbo].[Program] ([Id])
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_Skill] FOREIGN KEY([SkillId])
REFERENCES [dbo].[Skill] ([Id])
GO
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_Skill]
GO
ALTER TABLE [dbo].[QuestionOptions]  WITH CHECK ADD  CONSTRAINT [FK_QuestionOptions_Option] FOREIGN KEY([OptionId])
REFERENCES [dbo].[Option] ([Id])
GO
ALTER TABLE [dbo].[QuestionOptions] CHECK CONSTRAINT [FK_QuestionOptions_Option]
GO
ALTER TABLE [dbo].[QuestionOptions]  WITH CHECK ADD  CONSTRAINT [FK_QuestionOptions_Question] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Question] ([Id])
GO
ALTER TABLE [dbo].[QuestionOptions] CHECK CONSTRAINT [FK_QuestionOptions_Question]
GO
ALTER TABLE [dbo].[Scholar]  WITH CHECK ADD  CONSTRAINT [FK_Scholar_PersonId] FOREIGN KEY([PersonId])
REFERENCES [dbo].[Person] ([Id])
GO
ALTER TABLE [dbo].[Scholar] CHECK CONSTRAINT [FK_Scholar_PersonId]
GO
ALTER TABLE [dbo].[Scholar]  WITH CHECK ADD  CONSTRAINT [FK_Scholar_StatusType] FOREIGN KEY([StatusTypeId])
REFERENCES [dbo].[StatusType] ([Id])
GO
ALTER TABLE [dbo].[Scholar] CHECK CONSTRAINT [FK_Scholar_StatusType]
GO
ALTER TABLE [dbo].[Scholar]  WITH CHECK ADD  CONSTRAINT [FK_Scholar_Subject] FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subject] ([Id])
GO
ALTER TABLE [dbo].[Scholar] CHECK CONSTRAINT [FK_Scholar_Subject]
GO
ALTER TABLE [dbo].[ScholarPrograms]  WITH CHECK ADD  CONSTRAINT [FK_ScholarPrograms_ScholarId] FOREIGN KEY([ScholarId])
REFERENCES [dbo].[Scholar] ([Id])
GO
ALTER TABLE [dbo].[ScholarPrograms] CHECK CONSTRAINT [FK_ScholarPrograms_ScholarId]
GO
ALTER TABLE [dbo].[Stage]  WITH CHECK ADD  CONSTRAINT [FK_Stage_ProgramVersionId] FOREIGN KEY([ProgramVersionId])
REFERENCES [dbo].[ProgramVersion] ([Id])
GO
ALTER TABLE [dbo].[Stage] CHECK CONSTRAINT [FK_Stage_ProgramVersionId]
GO
ALTER TABLE [dbo].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_HistoryStatus_Scholar] FOREIGN KEY([ScholarId])
REFERENCES [dbo].[Scholar] ([Id])
GO
ALTER TABLE [dbo].[StatusHistory] CHECK CONSTRAINT [FK_HistoryStatus_Scholar]
GO
ALTER TABLE [dbo].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_StatusType] FOREIGN KEY([OldStatus])
REFERENCES [dbo].[StatusType] ([Id])
GO
ALTER TABLE [dbo].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_StatusType]
GO
ALTER TABLE [dbo].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_StatusType1] FOREIGN KEY([OldStatus])
REFERENCES [dbo].[StatusType] ([Id])
GO
ALTER TABLE [dbo].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_StatusType1]
GO
ALTER TABLE [dbo].[StatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_StatusHistory_Subject] FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subject] ([Id])
GO
ALTER TABLE [dbo].[StatusHistory] CHECK CONSTRAINT [FK_StatusHistory_Subject]
GO
ALTER TABLE [dbo].[StatusType]  WITH CHECK ADD  CONSTRAINT [FK_StatusType_StatusType] FOREIGN KEY([Id])
REFERENCES [dbo].[StatusType] ([Id])
GO
ALTER TABLE [dbo].[StatusType] CHECK CONSTRAINT [FK_StatusType_StatusType]
GO
ALTER TABLE [dbo].[SubjectEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SubjectEvaluation_Scholar] FOREIGN KEY([ScholarId])
REFERENCES [dbo].[Scholar] ([Id])
GO
ALTER TABLE [dbo].[SubjectEvaluation] CHECK CONSTRAINT [FK_SubjectEvaluation_Scholar]
GO
ALTER TABLE [dbo].[SubjectEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SubjectEvaluation_Subject] FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subject] ([Id])
GO
ALTER TABLE [dbo].[SubjectEvaluation] CHECK CONSTRAINT [FK_SubjectEvaluation_Subject]
GO
ALTER TABLE [dbo].[SubjectEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SubjectEvaluation_Grade] FOREIGN KEY([GradeId])
REFERENCES [dbo].[Grade] ([Id])
GO
ALTER TABLE [dbo].[SubjectEvaluation] CHECK CONSTRAINT [FK_SubjectEvaluation_Grade]
GO
ALTER TABLE [dbo].[Subject]  WITH CHECK ADD  CONSTRAINT [FK_Subject_StageId] FOREIGN KEY([StageId])
REFERENCES [dbo].[Stage] ([Id])
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [FK_Subject_StageId]
GO
/****** Object:  StoredProcedure [dbo].[uspGetScholarListWithLastEvaluation]    Script Date: 31/05/2022 18:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[uspGetScholarListWithLastEvaluation]
	@SubjectId VARCHAR(40)
AS
BEGIN
	SELECT S.Id, P.FirstName + ' ' + P.LastName ScholarName, E.EvaluationDate LastGradeDate, 
		G.Name Grade, G.Color, E.Comment LastComment, E.Id SubjectEvaluationId
	FROM 
	(
		SELECT S.Id, MAX(EvaluationDate) MaximunDate 
		FROM Scholar S LEFT JOIN SubjectEvaluation E ON (E.IsPublished = 1  AND S.Id = E.ScholarId)
		WHERE S.SubjectId = @SubjectId
		GROUP BY S.Id
	) T
	LEFT JOIN Scholar S ON (T.Id = S.Id)
	LEFT JOIN Person P ON (S.PersonId = P.Id)
	LEFT JOIN SubjectEvaluation E ON (S.Id = E.ScholarId AND T.MaximunDate = E.EvaluationDate)
	LEFT JOIN Grade G ON (E.GradeId = G.Id)
	ORDER BY P.FirstName, P.LastName	
END
GO
