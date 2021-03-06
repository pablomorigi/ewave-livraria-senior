﻿using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ToDo.Domain.Entities;
using ToDo.Domain.Entities.Livro;

namespace ToDo.EF.Data.Mapping
{
    public class AutorMapping : IEntityTypeConfiguration<Autor>
    {
        public void Configure(EntityTypeBuilder<Autor> builder)
        {
            builder.ToTable("Autor").HasKey(x => x.Id);
            builder.Property(x => x.AggregateId);
            builder.Property(x => x.DataCriacao);
            builder.Property(x => x.Ativo);
            builder.Property(x => x.Nome);
        }
    }
}