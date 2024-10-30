INSERT INTO _User (id, _name, email, username, photo, _password, phone_number, biography, linkedin, instagram, twitter, youtube, tiktok, is_organization, is_approved, is_admin, creation_date, id_institutioncourse) VALUES
-- Estudantes Normais
(1, 'Ana Silva', 'ana.silva@example.com', 'anasilva', 'photo1.jpg', 'hashed_password1', '912345678', 'Estudante de Engenharia Informática.', NULL, NULL, NULL, NULL, NULL, false, false, false, '2024-01-01', 'inst1'),
(2, 'João Pereira', 'joao.pereira@example.com', 'joaopereira', 'photo2.jpg', 'hashed_password2', '913456789', 'Estudante de Ciências da Computação.', 'linkedin.com/in/joao', 'instagram.com/joao', 'twitter.com/joao', 'youtube.com/joao', 'tiktok.com/joao', false, false, false, '2024-01-01', 'inst2'),
(3, 'Maria Santos', 'maria.santos@example.com', 'mariasantos', 'photo3.jpg', 'hashed_password3', '914567890', 'Estudante de Engenharia Informática.', 'linkedin.com/in/maria', 'instagram.com/maria', 'twitter.com/maria', 'youtube.com/maria', 'tiktok.com/maria', false, false, false, '2024-01-01', 'inst1'),

-- Organizações
(4, 'Organização A', 'org.a@example.com', 'orgA', 'org_photo1.jpg', 'hashed_password4', '915678901', 'Organização focada em tecnologia.', 'linkedin.com/in/orgA', 'instagram.com/orgA', 'twitter.com/orgA', 'youtube.com/orgA', 'tiktok.com/orgA', true, true, false, '2024-01-01', NULL),
(5, 'Organização B', 'org.b@example.com', 'orgB', 'org_photo2.jpg', 'hashed_password5', '916789012', 'Organização focada em educação.', 'linkedin.com/in/orgB', 'instagram.com/orgB', 'twitter.com/orgB', 'youtube.com/orgB', 'tiktok.com/orgB', true, false, false, '2024-01-01', NULL),

-- Administradores
(6, 'Carlos Gomes', 'carlos.gomes@example.com', 'carlosg', 'admin_photo1.jpg', 'hashed_password6', '917890123', 'Administrador da plataforma.', 'linkedin.com/in/carlos', 'instagram.com/carlos', 'twitter.com/carlos', 'youtube.com/carlos', 'tiktok.com/carlos', false, false, true, '2024-01-01', NULL),
(7, 'Fernanda Lima', 'fernanda.lima@example.com', 'fernandal', 'admin_photo2.jpg', 'hashed_password7', '918901234', 'Administradora da plataforma.', 'linkedin.com/in/fernanda', 'instagram.com/fernanda', 'twitter.com/fernanda', 'youtube.com/fernanda', 'tiktok.com/fernanda', false, false, true, '2024-01-01', NULL);

-- Inserir dados na tabela _Event
INSERT INTO _Event (id, title, _description, photo, is_online, link, is_hidden, limit_registration_date, event_date, duration, max_capacity, is_approved, id_location) VALUES
-- Evento organizado por uma organização online
('event1', 'Webinar sobre Tecnologias Futuras', 'Discussão sobre as tendências em tecnologia.', 'event_photo1.jpg', true, 'http://linktoevent1.com', false, '2024-12-01', '2024-12-05', 120, 100, true, NULL),

-- Evento organizado por uma organização presencial
('event2', 'Workshop de Programação', 'Aprenda a programar em Python.', 'event_photo2.jpg', false, NULL, false, '2024-11-01', '2024-11-10', 180, 50, true, NULL),

-- Evento oculto
('event3', 'Evento Secreto', 'Detalhes apenas para convidados.', 'event_photo3.jpg', false, NULL, true, '2024-12-01', '2024-12-15', 60, 20, true, NULL),

-- Eventos organizados por estudantes
('event4', 'Festa de Aniversário da Universidade', 'Celebração anual da universidade.', 'event_photo4.jpg', false, NULL, false, '2024-11-01', '2024-11-20', 240, 200, false, NULL),
('event5', 'Reunião do Clube de Tecnologia', 'Encontro para discutir projetos de tecnologia.', 'event_photo5.jpg', false, NULL, false, '2024-11-05', '2024-11-15', 120, 50, true, NULL),
('event6', 'Seminário de Inovação', 'Inovação em projetos de software.', 'event_photo6.jpg', true, 'http://linktoseminar.com', false, '2024-11-10', '2024-11-25', 90, 100, true, NULL),
('event7', 'Exposição de Arte Estudantil', 'Exposição das melhores artes dos alunos.', 'event_photo7.jpg', false, NULL, false, '2024-11-15', '2024-12-01', 180, 75, false, NULL),
('event8', 'Conferência de Sustentabilidade', 'Discutindo práticas sustentáveis.', 'event_photo8.jpg', true, 'http://linktoconference.com', false, '2024-11-20', '2024-12-05', 150, 300, false, NULL),
('event9', 'Aula Aberta de Matemática', 'Aula sobre temas avançados de matemática.', 'event_photo9.jpg', false, NULL, false, '2024-11-25', '2024-12-10', 120, 40, false, NULL),
('event10', 'Hackathon Estudantil', 'Desenvolvimento de projetos em 48 horas.', 'event_photo10.jpg', false, NULL, false, '2024-11-30', '2024-12-12', 48, 50, true, NULL);


INSERT INTO InstitutionCourse (id, institution, course) VALUES

-- Faculdade de Arquitetura
(1, 'Faculdade de Arquitetura', 'Mestrado Integrado em Arquitetura'),
(2, 'Faculdade de Arquitetura', 'Licenciatura em Arquitetura Paisagista'),

-- Faculdade de Belas Artes
(3, 'Faculdade de Belas Artes', 'Licenciatura em Artes Plásticas'),
(4, 'Faculdade de Belas Artes', 'Licenciatura em Desenho'),
(5, 'Faculdade de Belas Artes', 'Licenciatura em Design de Comunicação'),

-- Faculdade de Ciências
(6, 'Faculdade de Ciências', 'Licenciatura em Biologia'),
(7, 'Faculdade de Ciências', 'Licenciatura em Bioinformática'),
(8, 'Faculdade de Ciências', 'Licenciatura em Bioquímica'),
(9, 'Faculdade de Ciências', 'Licenciatura em Ciência de Computadores'),
(10, 'Faculdade de Ciências', 'Licenciatura em Ciências e Tecnologia do Ambiente'),
(11, 'Faculdade de Ciências', 'Licenciatura em Engenharia Agronómica'),
(12, 'Faculdade de Ciências', 'Licenciatura em Engenharia Física'),
(13, 'Faculdade de Ciências', 'Licenciatura em Engenharia Geoespacial'),
(14, 'Faculdade de Ciências', 'Licenciatura em Física'),
(15, 'Faculdade de Ciências', 'Licenciatura em Geologia'),
(16, 'Faculdade de Ciências', 'Licenciatura em Inteligência Artificial e Ciência de Dados'),
(17, 'Faculdade de Ciências', 'Licenciatura em Matemática'),
(18, 'Faculdade de Ciências', 'Licenciatura em Matemática Aplicada'),
(19, 'Faculdade de Ciências', 'Licenciatura em Química'),

-- Faculdade de Ciências da Nutrição e Alimentação
(20, 'Faculdade de Ciências da Nutrição e Alimentação', 'Licenciatura em Ciências da Nutrição'),

-- Faculdade de Desporto
(21, 'Faculdade de Desporto', 'Licenciatura em Ciências do Desporto'),

-- Faculdade de Direito
(22, 'Faculdade de Direito', 'Licenciatura em Criminologia'),
(23, 'Faculdade de Direito', 'Licenciatura em Direito'),

-- Faculdade de Economia
(24, 'Faculdade de Economia', 'Licenciatura em Economia'),
(25, 'Faculdade de Economia', 'Licenciatura em Gestão'),

-- Faculdade de Engenharia
(26, 'Faculdade de Engenharia', 'Licenciatura em Bioengenharia'),
(27, 'Faculdade de Engenharia', 'Licenciatura em Engenharia Aeroespacial'),
(28, 'Faculdade de Engenharia', 'Licenciatura em Engenharia Civil'),
(29, 'Faculdade de Engenharia', 'Licenciatura em Engenharia de Materiais'),
(30, 'Faculdade de Engenharia', 'Licenciatura em Engenharia de Minas e Geo-Ambiente'),
(31, 'Faculdade de Engenharia', 'Licenciatura em Engenharia do Ambiente'),
(32, 'Faculdade de Engenharia', 'Licenciatura em Engenharia e Biotecnologia Florestal'),
(33, 'Faculdade de Engenharia', 'Licenciatura em Engenharia e Gestão Industrial'),
(34, 'Faculdade de Engenharia', 'Licenciatura em Engenharia Eletrotécnica e de Computadores'),
(35, 'Faculdade de Engenharia', 'Licenciatura em Engenharia Informática e Computação'),
(36, 'Faculdade de Engenharia', 'Licenciatura em Engenharia Mecânica'),
(37, 'Faculdade de Engenharia', 'Licenciatura em Engenharia Química'),

-- Faculdade de Farmácia
(38, 'Faculdade de Farmácia', 'Mestrado Integrado em Ciências Farmacêuticas'),

-- Faculdade de Letras
(39, 'Faculdade de Letras', 'Licenciatura em Arqueologia'),
(40, 'Faculdade de Letras', 'Licenciatura em Ciência da Informação'),
(41, 'Faculdade de Letras', 'Licenciatura em Ciências da Comunicação'),
(42, 'Faculdade de Letras', 'Licenciatura em Ciências da Linguagem'),
(43, 'Faculdade de Letras', 'Licenciatura em Filosofia'),
(44, 'Faculdade de Letras', 'Licenciatura em Geografia'),
(45, 'Faculdade de Letras', 'Licenciatura em História'),
(46, 'Faculdade de Letras', 'Licenciatura em História da Arte'),
(47, 'Faculdade de Letras', 'Licenciatura em Línguas Aplicadas'),
(48, 'Faculdade de Letras', 'Licenciatura em Línguas e Relações Internacionais'),
(49, 'Faculdade de Letras', 'Licenciatura em Línguas, Literaturas e Culturas'),
(50, 'Faculdade de Letras', 'Licenciatura em Literatura e Estudos Interartes'),
(51, 'Faculdade de Letras', 'Licenciatura em Sociologia'),

-- Faculdade de Medicina
(52, 'Faculdade de Medicina', 'Mestrado Integrado em Medicina FMUP'),
(53, 'Faculdade de Medicina', 'Licenciatura em Saúde Digital e Inovação Biomédica'),

-- Faculdade de Medicina Dentária
(54, 'Faculdade de Medicina Dentária', 'Mestrado Integrado em Medicina Dentária'),

-- Faculdade de Psicologia e de Ciências da Educação
(55, 'Faculdade de Psicologia e de Ciências da Educação', 'Licenciatura em Ciências da Educação'),
(56, 'Faculdade de Psicologia e de Ciências da Educação', 'Licenciatura em Psicologia'),

-- Instituto de Ciências Biomédicas Abel Salazar
(57, 'Instituto de Ciências Biomédicas Abel Salazar', 'Licenciatura em Ciências do Meio Aquático'),
(58, 'Instituto de Ciências Biomédicas Abel Salazar', 'Mestrado Integrado em Medicina ICBAS'),
(59, 'Instituto de Ciências Biomédicas Abel Salazar', 'Mestrado Integrado em Medicina Veterinária');