from app.core.database import Base
from sqlalchemy import (Column, DateTime, ForeignKey, Integer, String, Text,
                        func, text)
from sqlalchemy.orm import relationship


class Work(Base):
    __tablename__ = "works"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    company_id = Column(Integer, ForeignKey("companies.id"))
    title = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    income = Column(Integer, nullable=True)
    location = Column(String(100), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(
        DateTime(timezone=True), server_default=text("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"), nullable=False
    )

    company = relationship("Company", back_populates="works")
