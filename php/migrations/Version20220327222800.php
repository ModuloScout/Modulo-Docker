<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20220327222800 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SEQUENCE age_section_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE role_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE scope_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE structure_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE SEQUENCE "user_id_seq" INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('CREATE TABLE age_section (id INT NOT NULL, name VARCHAR(50) NOT NULL, code VARCHAR(10) NOT NULL, color VARCHAR(50) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_E30B670D77153098 ON age_section (code)');
        $this->addSql('CREATE TABLE role (id INT NOT NULL, age_section_id INT DEFAULT NULL, name VARCHAR(100) NOT NULL, code VARCHAR(10) NOT NULL, feminine_name VARCHAR(100) DEFAULT NULL, icon VARCHAR(50) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_57698A6AD3F77268 ON role (age_section_id)');
        $this->addSql('CREATE TABLE scope (id INT NOT NULL, user_id INT DEFAULT NULL, structure_id INT DEFAULT NULL, role_id INT DEFAULT NULL, active BOOLEAN NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_AF55D3A76ED395 ON scope (user_id)');
        $this->addSql('CREATE INDEX IDX_AF55D32534008B ON scope (structure_id)');
        $this->addSql('CREATE INDEX IDX_AF55D3D60322AC ON scope (role_id)');
        $this->addSql('CREATE TABLE structure (id INT NOT NULL, parent_structure_id INT DEFAULT NULL, name VARCHAR(100) NOT NULL, code VARCHAR(10) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_6F0137EA755A5DA5 ON structure (parent_structure_id)');
        $this->addSql('CREATE TABLE "user" (id INT NOT NULL, uuid VARCHAR(96) NOT NULL, email VARCHAR(200) NOT NULL, roles JSON NOT NULL, password VARCHAR(255) NOT NULL, first_name VARCHAR(255) NOT NULL, last_name VARCHAR(255) NOT NULL, genre VARCHAR(1) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_8D93D649D17F50A6 ON "user" (uuid)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_8D93D649E7927C74 ON "user" (email)');
        $this->addSql('ALTER TABLE role ADD CONSTRAINT FK_57698A6AD3F77268 FOREIGN KEY (age_section_id) REFERENCES age_section (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE scope ADD CONSTRAINT FK_AF55D3A76ED395 FOREIGN KEY (user_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE scope ADD CONSTRAINT FK_AF55D32534008B FOREIGN KEY (structure_id) REFERENCES structure (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE scope ADD CONSTRAINT FK_AF55D3D60322AC FOREIGN KEY (role_id) REFERENCES role (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE structure ADD CONSTRAINT FK_6F0137EA755A5DA5 FOREIGN KEY (parent_structure_id) REFERENCES structure (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE role DROP CONSTRAINT FK_57698A6AD3F77268');
        $this->addSql('ALTER TABLE scope DROP CONSTRAINT FK_AF55D3D60322AC');
        $this->addSql('ALTER TABLE scope DROP CONSTRAINT FK_AF55D32534008B');
        $this->addSql('ALTER TABLE structure DROP CONSTRAINT FK_6F0137EA755A5DA5');
        $this->addSql('ALTER TABLE scope DROP CONSTRAINT FK_AF55D3A76ED395');
        $this->addSql('DROP SEQUENCE age_section_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE role_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE scope_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE structure_id_seq CASCADE');
        $this->addSql('DROP SEQUENCE "user_id_seq" CASCADE');
        $this->addSql('DROP TABLE age_section');
        $this->addSql('DROP TABLE role');
        $this->addSql('DROP TABLE scope');
        $this->addSql('DROP TABLE structure');
        $this->addSql('DROP TABLE "user"');
    }
}
