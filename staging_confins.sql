CREATE TABLE [dbo].[staging_confins_header] (
    [id]                INT          IDENTITY (1, 1) NOT NULL,
    [submission_number] VARCHAR (50) NULL,
    [created_date]      DATETIME     NULL,
    CONSTRAINT [PK_staging_confins_header] PRIMARY KEY CLUSTERED ([id] ASC)
);

CREATE TABLE [dbo].[staging_confins_data] (
    [submission_number] VARCHAR (50)  NOT NULL,
    [question_code]     VARCHAR (50)  NOT NULL,
    [question_name]     VARCHAR (100) NULL,
    [question_value]    TEXT          NULL,
    [question_lat]      FLOAT (53)    NULL,
    [question_lon]      FLOAT (53)    NULL,
    CONSTRAINT [PK_staging_confins_data] PRIMARY KEY CLUSTERED ([submission_number] ASC, [question_code] ASC)
);